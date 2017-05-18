class TimeTableGeneratorBkpOne


  SSE = Struct.new(:section_id,:subject_id,:employee_id)


  Subject  = Struct.new(:id,:sub_code,:section_count,:emp_count,:class_id,:max_classes,:is_core_subject,:available_sections,:allotted_sections)
  Employee = Struct.new(:id,:sub_count,:section_count,:class_count,:max_classes,:allotted_count,:assignments,:assigned_subjects,:assigned_batches)
  Section  = Struct.new(:id,:course_id,:class_teacher_id,:timings_count,:lectures_count,:assignments,:assigned_subjects)
  Class    = Struct.new(:id,:section_stats,:subject_stats,:employee_stats,:total_timings,:total_lectures)
  Chromosome = Struct.new(:time_table_entries, :fitness_score, :class_stats)

  Timing = Struct.new(:id)
  Weekday = Struct.new(:id,:timings)

  Entry = Struct.new(:mg_weekday_id,:mg_class_timings_id,:mg_batch_id,:mg_subject_id,:mg_employee_id,:mg_school_id)

  def initialize
    @sse_array = Array.new
    @sse_hash = Hash.new
    @population = Array.new
    @all_emp_stats = Hash.new
    @all_sub_stats = Hash.new
    @tt_entries = Array.new
    @all_class_teacher_id_list = Array.new
  end


  def create_time_table(school_id)
      puts "Creating Timetable"

      #-----------------SSE
      index = 0
      course_list = MgCourse.where(:is_deleted=>0,:mg_school_id=>school_id)

      class_stats = Hash.new

      weekday_hash = Hash.new


      @all_class_teacher_id_list = MgBatch.where(:is_deleted => 0,:mg_school_id => school_id).pluck(:mg_employee_id)

      course_list.each do |course|

        section_stats = Hash.new
        subject_stats = Hash.new
        employee_stats = Hash.new

        weekdays=MgWeekday.where(:is_deleted=>0,:mg_school_id=>school_id,:mg_wing_id=>course.mg_wing_id)

         total_classes = 0

         weekday_index = 1
         weekdays.order(:weekday).each do |day|
            puts day.weekday
            timings = MgClassTiming.where(:is_deleted=>0,:mg_school_id=>school_id,:mg_weekday_id=>day.id,:is_break=>0)
            total_classes+=timings.size

              timing_hash = Hash.new
              time_index = 1
              timings.order(:start_time).each do |time|
                          #puts "#{time.start_time.strftime("%k:%M %p")}-#{time.end_time.strftime("%k:%M %p")}"
                timing_hash[time_index]=time
                time_index+=1
              end
            weekday_hash[weekday_index] = Weekday.new(day.id,timing_hash)
            weekday_index+=1
            end

        batch_list=MgBatch.where(:is_deleted=>0,:mg_school_id=>school_id,:mg_course_id=>course.id)

        total_lectures = 0
        subjects = MgSubject.where(:is_deleted=>0,:mg_school_id=>school_id,:mg_course_id=>course.id)

        subjects.each do |sub|

            total_lectures+=sub.max_weekly_class

            emp_subject_list=MgEmployeeSubject.where(:is_deleted=>0,:mg_school_id=>school_id,:mg_subject_id=>sub.id)

            emp_subject_list.each do |es|

              #----------Building SSE
              batch_list.each do |batch|

                temp_sse = SSE.new(batch.id,sub.id,es.mg_employee_id)
                @sse_array.push(temp_sse)
                @sse_hash[index] =    temp_sse
                index+=1

              end




              #----------initiating Subject Stats
              temp_sub = Subject.new(sub.id,sub.subject_code,batch_list.count,emp_subject_list.count,sub.mg_course_id,sub.max_weekly_class,sub.is_core,batch_list.pluck(:id),Array.new)
              subject_stats[sub.id]=temp_sub

              #--------initiating Employee Stats
              active_subject_ids = MgSubject.where(:is_deleted=>0,:mg_school_id=>school_id).pluck(:id)
              curr_emp_subjects = MgEmployeeSubject.where(:mg_employee_id=>es.mg_employee_id,:mg_subject_id=>active_subject_ids)
              course_id_list = MgSubject.where(:is_deleted=>0,:mg_school_id=>school_id,:id=>curr_emp_subjects.pluck(:mg_subject_id)).pluck(:mg_course_id).uniq
              section_count = MgBatch.where(:is_deleted=>0,:mg_school_id=>school_id,:mg_course_id=>course_id_list).count
              emp = MgEmployee.find(es.mg_employee_id)

              temp_emp = Employee.new(es.mg_employee_id,curr_emp_subjects.count,section_count,course_id_list.count,emp.max_no_of_class,Array.new)
              employee_stats[es.mg_employee_id]= temp_emp

            end

        end


        batch_list.each do |batch|

          temp_section = Section.new(batch.id,course.id,batch.mg_employee_id,0,0,nil,nil)
          section_stats[batch.id]=temp_section
          #puts ""
          #puts ""
          #puts ""
          #puts ""
          #puts "Section Stats"
          #puts section_stats
          #puts ""
        end

        @all_emp_stats = @all_emp_stats.merge(employee_stats)
        @all_sub_stats = @all_sub_stats.merge(subject_stats)

         temp_class =Class.new(course.id,section_stats,subject_stats,employee_stats,total_classes,total_lectures)
        puts ""
        puts ""
        puts ""
        puts ""
        puts "Class Stats"
        puts temp_class.inspect
         class_stats[course.id]= temp_class

     end

    puts "Array"
    puts @sse_array.inspect
    puts "Hash"
    puts @sse_hash.inspect

    puts "pos 50"
    puts @sse_array[50]
    puts @sse_hash[50]

    generate_population(@sse_array,class_stats)


      puts "Subject Stats"
      puts  @all_sub_stats.inspect
      puts "Employee Stats"
      puts  @all_emp_stats.inspect

      puts ""


    class_stats.each do |class_id,cl_st|
      sec_sts = cl_st['section_stats']
      sub_sts = cl_st['subject_stats']
      assigned_employees = Array.new

      puts sec_sts.inspect

      #----------------Assigning Class teacher subjects
        sec_sts.each do |section_id,sec_st|
          #sec_st = sec_sts[section_id]

          class_teacher_id = sec_st["class_teacher_id"]

          assigned_employees.push(class_teacher_id)

          subject_id_list =  MgEmployeeSubject.where(:mg_employee_id=>class_teacher_id,:mg_subject_id=>sub_sts.keys).pluck(:mg_subject_id)

          min_emp_sub_id = nil
          min_emp_count = 10000

          subject_id_list.each do |sub_id|
            sub_st = sub_sts[sub_id]
            emp_count = sub_st["emp_count"]
            max_classes = sub_st["max_classes"]



            found_sub = false
            @tt_entries.each do |curr_entry|
              if( (curr_entry["mg_subject_id"]==sub_id) && (curr_entry["mg_batch_id"]==sec_id) )
                found_sub = true
                break
              end
            end

            puts @all_sub_stats[sub_id]["is_core_subject"]

           #if ((min_emp_count > emp_count) && (max_classes==6) && !found_sub)
            if ((min_emp_count > emp_count) && (@all_sub_stats[sub_id]["is_core_subject"]) && !found_sub)

             min_emp_sub_id = sub_id
             min_emp_count = emp_count
           end

          end

          period_index = 1
          (1..weekday_hash.length).each do |n|

             tt_entry =  Entry.new(n,period_index,section_id,min_emp_sub_id,class_teacher_id,school_id)
              @tt_entries.push(tt_entry)
              puts "Class Id = #{class_id}"
              puts "Section Id = #{section_id}"
              puts "Employee Id = #{class_teacher_id}"
              puts "Subject Id = #{min_emp_sub_id}"

              puts ""
          end
          period_index+=1

          sec_sts.keys.each do |sec_id|

            #flag = true
            start_index = 2
            (start_index..weekday_hash[1]["timings"].length).each do |n|
              found = false
              @tt_entries.each do |curr_entry|
                 if( (curr_entry["mg_class_timings_id"]==start_index) && ((curr_entry["mg_batch_id"]==sec_id) ||(curr_entry["mg_employee_id"]==class_teacher_id)))
                   found = true
                   break
                 end
              end
              if(found)
                start_index+=1
              else
                break
              end
            end


            assigned_count = 0
            @tt_entries.each do |curr_entry|
              if( (curr_entry["mg_weekday_id"]==1) && (curr_entry["mg_employee_id"]==class_teacher_id) )
                assigned_count += 1
              end
            end

            #puts @all_emp_stats[class_teacher_id]

            if(start_index<=weekday_hash[1]["timings"].length && assigned_count<@all_emp_stats[class_teacher_id]["max_classes"])
              if(sec_id!=section_id)
                (1..weekday_hash.length).each do |n|
                  tt_entry =  Entry.new(n,start_index,sec_id,min_emp_sub_id,class_teacher_id,school_id)
                  @tt_entries.push(tt_entry)
                end
              end
            end

          end

        end



      #----------------Assigning remaining core subjects
      sub_sts.each do |sub_id,sub_st|
        #sub_st = sub_sts[sub_id]
        emp_count = sub_st["emp_count"]
        max_classes = sub_st["max_classes"]

        #curr_sub_id = nil
        #curr_emp_id = nil
        #min_emp_count = 10000

         found_sub = false
         @tt_entries.each do |curr_entry|
           if( (curr_entry["mg_subject_id"]==sub_id) && (sec_sts.keys.include? curr_entry["mg_batch_id"]))
             found_sub = true
             break
           end
         end

        # if ((min_emp_count > emp_count) && (max_classes==6) && !found_sub)
        #   min_emp_sub_id = sub_id
        #   min_emp_count = emp_count
        #

            #if(max_classes==6 && !found_sub)
            if(@all_sub_stats[sub_id]["is_core_subject"] && !found_sub)
              @emp_id_list = MgEmployeeSubject.where(:is_deleted => 0,:mg_subject_id => sub_id).pluck(:mg_employee_id)

              min_sub_emp_id = nil
              min_sub_count = 10000
              assigned_count = 0
              @emp_id_list.each do |emp_id|



                assigned_count = 0
                @tt_entries.each do |curr_entry|
                  if( (curr_entry["mg_weekday_id"]==1) && (curr_entry["mg_employee_id"]==emp_id) )
                    assigned_count += 1
                  end
                end


                if(assigned_count<@all_emp_stats[emp_id]["max_classes"])

                unless(assigned_employees.include? emp_id)
                #unless(@all_class_teacher_id_list.include? emp_id)
                  curr_emp_stat = @all_emp_stats[emp_id]
                  if(min_sub_count > curr_emp_stat["sub_count"])

                    min_sub_count = curr_emp_stat["sub_count"]
                    min_sub_emp_id = emp_id

                  end

                end

                end
              end

                sec_sts.keys.each do |sec_id|

                  #flag = true
                  start_index = 2
                  (start_index..weekday_hash[1]["timings"].length).each do |n|
                    found = false
                    @tt_entries.each do |curr_entry|

                      # puts "#{curr_entry["mg_class_timings_id"]}==#{start_index}"
                      # puts (curr_entry["mg_class_timings_id"]==start_index)
                      # puts "#{curr_entry["mg_batch_id"]}==#{sec_id}"
                      # puts (curr_entry["mg_batch_id"]==sec_id)
                      # puts "#{assigned_employees}.include? #{curr_entry["mg_employee_id"]}"
                      # puts (assigned_employees.include? curr_entry["mg_employee_id"])
                      # puts ((curr_entry["mg_batch_id"]==sec_id) ||(assigned_employees.include? curr_entry["mg_employee_id"]))
                      # puts (curr_entry["mg_class_timings_id"]==start_index) &&
                      #          ((curr_entry["mg_batch_id"]==sec_id) ||(assigned_employees.include? curr_entry["mg_employee_id"]))


                      if( (curr_entry["mg_class_timings_id"]==start_index) &&
                          ( (curr_entry["mg_batch_id"]==sec_id) ||(curr_entry["mg_employee_id"]==min_sub_emp_id))
                        )
                        found = true
                        break
                      end
                    end
                    if(found)
                      start_index+=1
                    else
                      break
                    end
                  end

                  if(min_sub_emp_id==9)
                    puts assigned_count
                    puts "Jayanth"
                  end


                  if(start_index<=weekday_hash[1]["timings"].length && assigned_count<@all_emp_stats[min_sub_emp_id]["max_classes"])
                    assigned_count+=1
                      (1..weekday_hash.length).each do |n|
                      tt_entry =  Entry.new(n,start_index,sec_id,sub_id,min_sub_emp_id,school_id)
                      @tt_entries.push(tt_entry)
                      end
                  else
                     @emp_id_list.each do |emp_id|

                       assigned_count = 0
                       @tt_entries.each do |curr_entry|
                         if( (curr_entry["mg_weekday_id"]==1) && (curr_entry["mg_employee_id"]==emp_id) )
                           assigned_count += 1
                         end
                       end


                       if(assigned_count<@all_emp_stats[emp_id]["max_classes"])

                            if(emp_id!=min_sub_emp_id)
                             free_period = true
                             (2..weekday_hash[1]["timings"].length).each do |curr_period|

                               free_period = true
                               @tt_entries.each do |curr_entry|
                                 if( (curr_entry["mg_class_timings_id"]==curr_period) && ( (curr_entry["mg_batch_id"]==sec_id) || (curr_entry["mg_employee_id"]==emp_id)))
                                   free_period = false
                                   break
                                 end
                               end

                               if(free_period)
                                 (1..weekday_hash.length).each do |n|
                                    tt_entry =  Entry.new(n,curr_period,sec_id,sub_id,emp_id,school_id)
                                    @tt_entries.push(tt_entry)
                                 end
                                 break
                               end

                             end


                             if(free_period)
                               break
                             else
                               puts "not Assigned subject =#{sub_id} and batch = #{sec_id} "
                             end
                         end
                        end
                     end
                  end
                end

            end

        # end

      end


    end




     #--------Assigning Non Core Subjects

      class_stats.each do |class_id,cl_st|
        sec_sts = cl_st['section_stats']
        sub_sts = cl_st['subject_stats']

        sec_sts.keys.each do |sec_id|

          n=1
          sub_sts.each do |sub_id,sub_st|
            #sub_st = sub_sts[sub_id]
            emp_count = sub_st["emp_count"]
            max_classes = sub_st["max_classes"]

            #if(max_classes<6)
            if(!@all_sub_stats[sub_id]["is_core_subject"])
              found_sub = false
              @tt_entries.each do |curr_entry|
                if( (curr_entry["mg_subject_id"]==sub_id) && (curr_entry["mg_batch_id"]==sec_id))
                  found_sub = true
                  break
                end
              end

              if(!found_sub)

                emp_id_list = MgEmployeeSubject.where(:is_deleted => 0,:mg_subject_id => sub_id).pluck(:mg_employee_id)


                (1..max_classes).each do |count|
                  emp_id_list.each do |emp_id|

                  #(1..max_classes).each do |count|
                    free_period = true
                    (1..weekday_hash.length).each do |wday|
                    #(1..5).each do |wday|
                    #while n>0
                        #free_period = true

                      if(wday==6)
                        puts weekday_hash[wday]["timings"].length
                        puts "Saturday"
                      end
                        (2..weekday_hash[wday]["timings"].length).each do |curr_period|

                          free_period = true
                          @tt_entries.each do |curr_entry|
                            if((curr_entry["mg_weekday_id"]==n &&  curr_entry["mg_class_timings_id"]==curr_period) && ( (curr_entry["mg_batch_id"]==sec_id) || (curr_entry["mg_employee_id"]==emp_id)))
                              free_period = false
                              break
                            end

                            if(curr_entry["mg_weekday_id"]==n && curr_entry["mg_subject_id"]==sub_id && curr_entry["mg_batch_id"]==sec_id)
                              free_period = false
                              break
                            end

                          end

                          if(free_period)
                            #(1..weekday_hash.length).each do |n|
                              tt_entry =  Entry.new(n,curr_period,sec_id,sub_id,emp_id,school_id)
                              @tt_entries.push(tt_entry)
                            #end
                            break
                          end

                        end

                        puts "n = #{n}"
                        if n==weekday_hash.length

                        #if n==5
                          n=1
                        else
                          n+=1
                        end


                        if(free_period)
                          break
                        end


                    end


                    if(free_period)
                      break
                    else
                      puts "not Assigned subject =#{sub_id} and batch = #{sec_id} "
                    end

                  end

                end

              end

            end

          end

        end


       end


     #------Filling unassigned timings

      # class_stats.each do |class_id,cl_st|
      #   sec_sts = cl_st['section_stats']
      #   sub_sts = cl_st['subject_stats']
      #
      #   sec_sts.keys.each do |sec_id|
      #
      #
      #     sub_sts.each do |sub_id,sub_st|
      #       #sub_st = sub_sts[sub_id]
      #       emp_count = sub_st["emp_count"]
      #       max_classes = sub_st["max_classes"]
      #
      #       assigned_count = 0
      #
      #       @tt_entries.each do |curr_entry|
      #
      #         if( (curr_entry["mg_class_timings_id"]==curr_period) && ( (curr_entry["mg_batch_id"]==sec_id) || (curr_entry["mg_employee_id"]==emp_id)))
      #
      #         end
      #
      #       end
      #
      #
      #     end
      #   end
      # end


     puts  @tt_entries.inspect
     puts ""

      #-------------Inserting to database
      MgTimeTableEntry.delete_all(:mg_school_id=>school_id)

      @tt_entries.each do |curr_entry|
        # puts "Batch = #{curr_entry['mg_batch_id']}"
        # week_day = weekday_hash[curr_entry["mg_weekday_id"]]
        # puts "Weekday = #{week_day['id']}"
        # timing = week_day["timings"][curr_entry['mg_class_timings_id']]
        # puts "Timing = #{timing.id}"
        # puts "Subject = #{curr_entry['mg_subject_id']}"
        # puts "Employee = #{curr_entry['mg_employee_id']}"
        # puts "School = #{curr_entry['mg_school_id']}"
        # #break


        time_table_entry= MgTimeTableEntry.new

        week_day = weekday_hash[curr_entry["mg_weekday_id"]]
        time_table_entry.mg_weekday_id=week_day['id']

        timing = week_day["timings"][curr_entry['mg_class_timings_id']]

        time_table_entry.mg_batch_id=curr_entry['mg_batch_id']
        time_table_entry.mg_subject_id=curr_entry['mg_subject_id']
        time_table_entry.mg_employee_id=curr_entry['mg_employee_id']
        time_table_entry.mg_timetable_id=1
        time_table_entry.mg_school_id=curr_entry['mg_school_id']
        time_table_entry.is_deleted=0

        if timing != nil
          time_table_entry.mg_class_timings_id=timing.id
          time_table_entry.save
        end




      end







    #--------------------Employee


    # emp_array = Array.new
    # emp_subject_list=MgEmployeeSubject.where(:is_deleted=>0,:mg_school_id=>school_id)
    #
    # unique_emp_list = emp_subject_list.pluck(:mg_employee_id).uniq
    #
    # unique_emp_list.each do |emp|
    #   #puts "emp_id"
    #   #puts emp.inspect
    #
    #   curr_emp_subjects = emp_subject_list.where(:mg_employee_id=>emp)
    #   course_id_list = MgSubject.where(:is_deleted=>0,:mg_school_id=>school_id,:id=>curr_emp_subjects.pluck(:mg_subject_id)).pluck(:mg_course_id).uniq
    #   section_count = MgBatch.where(:is_deleted=>0,:mg_school_id=>school_id,:mg_course_id=>course_id_list).count
    #
    #   #puts "count"
    #   #puts section_count
    #   temp_emp = Employee.new(emp,curr_emp_subjects.count,section_count,course_id_list.count)
    #   emp_array.push(temp_emp)
    # end
    #
    # emp_array.each do |emp|
    #   puts emp.inspect
    # end

    #--------------------Subject

    # subject_array = Array.new
    #
    # subjects = MgSubject.where(:is_deleted=>0,:mg_school_id=>school_id)
    #
    # subjects.each do |sub|
    #   #puts sub.subject_code
    #
    #   batch_list=MgBatch.where(:is_deleted=>0,:mg_school_id=>school_id,:mg_course_id=>sub.mg_course_id)
    #   #puts batch_list.count
    #
    #   emp_subject_list=MgEmployeeSubject.where(:is_deleted=>0,:mg_school_id=>school_id,:mg_subject_id=>sub.id)
    #   #puts emp_subject_list.count
    #
    #   temp_sub = Subject.new(sub.id,sub.subject_code,batch_list.count,emp_subject_list.count,sub.mg_course_id,sub.max_weekly_class)
    #   subject_array.push(temp_sub)
    # end
    #
    # puts "Subject Data"
    #
    # #puts subject_array.inspect
    # subject_array.each do |sub|
    #   puts sub.inspect
    # end

    #--------------__Course


    # course_list = MgCourse.where(:is_deleted=>0,:mg_school_id=>school_id)
    #
    # course_list.each do |course|
    #
    # puts course.course_name
    #
    #
    # subjects = MgSubject.where(:is_deleted=>0,:mg_school_id=>school_id,:mg_course_id=>course.id)
    #
    # total_lectures = 0
    # subjects.each do |sub|
    #
    #   puts "#{sub.subject_code}-#{sub.max_weekly_class}"
    #   total_lectures+=sub.max_weekly_class
    #
    # end
    #
    #   puts "Total Lectures = #{total_lectures}"
    #
    #
    #  batch_list=MgBatch.where(:is_deleted=>0,:mg_school_id=>school_id,:mg_course_id=>course.id)
    #
    #        batch_list.each do |batch|
    #          puts batch.course_batch_name
    #
    #         weekdays=MgWeekday.where(:is_deleted=>0,:mg_school_id=>school_id,:mg_wing_id=>course.mg_wing_id)
    #
    #          total_classes = 0
    #            weekdays.order(:weekday).each do |day|
    #              puts day.weekday
    #              timings = MgClassTiming.where(:is_deleted=>0,:mg_school_id=>school_id,:mg_weekday_id=>day.id,:is_break=>0)
    #              total_classes+=timings.size
    #                #timings.order(:start_time).each do |time|
    #                  #puts "#{time.start_time.strftime("%k:%M %p")}-#{time.end_time.strftime("%k:%M %p")}"
    #                #end
    #
    #            end
    #          puts "Total Timings = #{total_classes}"
    #          puts "Total Lectures = #{total_lectures}"
    #        end
    #  end



    puts "Timetable Created"
  end

  def generate_population(sse,class_stats)
    puts "Population Start"

    puts "Population End"
  end


end