class TimeTableGenerator


  SSE = Struct.new(:section_id,:subject_id,:employee_id)


  Subject  = Struct.new(:id,:sub_code,:section_count,:emp_count,:class_id,:max_classes,:is_core_subject,:is_lab,:no_of_classes,:room_id,:available_sections,:allotted_sections)
  Employee = Struct.new(:id,:sub_count,:section_count,:class_count,:max_classes,:allotted_count,:assignments,:assigned_subjects,:assigned_batches)
  Section  = Struct.new(:id,:course_id,:class_teacher_id,:timings_count,:lectures_count,:assignments,:assigned_subjects)
  Class    = Struct.new(:id,:section_stats,:subject_stats,:employee_stats,:total_timings,:total_lectures)
  Chromosome = Struct.new(:time_table_entries, :fitness_score, :class_stats)

  Timing = Struct.new(:id)
  Weekday = Struct.new(:id,:timings)

  Entry = Struct.new(:mg_weekday_id,:mg_class_timings_id,:mg_batch_id,:mg_subject_id,:mg_employee_id,:mg_school_id,:mg_room_id)

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


      #---------------Validating time table


      #checking class teacher assignment
      no_class_teacher_sections =  MgBatch.where(:is_deleted => 0,:mg_school_id => school_id,:mg_employee_id=>nil)

      return_msg = ""

      section_size = no_class_teacher_sections.size
      if(section_size>0)
        return_msg += "Please assign class teacher to "
      end

      no_class_teacher_sections.each do |sec,index|
        return_msg += sec.course_batch_name
        if(index!=(section_size-1))
          return_msg+=", "
        end
        puts sec.course_batch_name
      end

      puts return_msg


      #checking class teacher subjects

       all_batches = MgBatch.where(:is_deleted => 0,:mg_school_id => school_id)

       unassigned_class_teachers = ""
       all_batches.each do |batch|

         class_teacher_id = batch.mg_employee_id

         if(class_teacher_id!=nil)
           class_subjects = MgSubject.where(:is_deleted=>0,:mg_school_id=>school_id,:mg_course_id=>batch.mg_course_id).pluck(:id)
           emp_subject_list=MgEmployeeSubject.where(:is_deleted=>0,:mg_school_id=>school_id,:mg_subject_id=>class_subjects,:mg_employee_id => class_teacher_id)
           if(emp_subject_list.size==0)
             emp_name = MgEmployee.find(class_teacher_id).employee_name
             unassigned_class_teachers+= "#{emp_name} (#{batch.course_batch_name}), "
           end
         end

      end

      if(unassigned_class_teachers!="")
        return_msg +="\nFollowing class teachers are not assigned subjects of their respective class #{unassigned_class_teachers}"

      end

      #Checking classes error

      less_periods_classes = ""

      class_stats = Hash.new

      weekday_hash = Hash.new

      emp_assignments = Hash.new

      @all_class_teacher_id_list = MgBatch.where(:is_deleted => 0,:mg_school_id => school_id).pluck(:mg_employee_id)

      course_list.each do |course|

        section_stats = Hash.new
        subject_stats = Hash.new
        employee_stats = Hash.new

        weekdays=MgWeekday.where(:is_deleted=>0,:mg_school_id=>school_id,:mg_wing_id=>course.mg_wing_id)

         total_classes = 0

         weekday_index = 1
         weekdays.order(:weekday).each do |day|
            #puts day.weekday
            timings = MgClassTiming.where(:is_deleted=>0,:mg_school_id=>school_id,:mg_weekday_id=>day.id,:is_break=>0)
            total_classes+=timings.size

              timing_hash = Hash.new
              emp_timing_hash =Hash.new
              time_index = 1
              timings.order(:start_time).each do |time|
                          #puts "#{time.start_time.strftime("%k:%M %p")}-#{time.end_time.strftime("%k:%M %p")}"
                timing_hash[time_index]=time
                emp_timing_hash[time_index] = false
                time_index+=1
              end
            weekday_hash[weekday_index] = Weekday.new(day.id,timing_hash)
            emp_assignments[weekday_index] = Marshal.load(Marshal.dump(emp_timing_hash))#emp_timing_hash.clone
            weekday_index+=1
            end

        batch_list=MgBatch.where(:is_deleted=>0,:mg_school_id=>school_id,:mg_course_id=>course.id)

        total_lectures = 0
        subjects = MgSubject.where(:is_deleted=>0,:mg_school_id=>school_id,:mg_course_id=>course.id)

        subjects.each do |sub|

          if(sub.is_lab)
            total_lectures+=(sub.max_weekly_class*sub.no_of_classes)
          else
            total_lectures+=sub.max_weekly_class
          end
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

              is_core = false
              if(sub.is_core!=nil)
                is_core = sub.is_core
              end
              is_lab = false
              if(sub.is_lab!=nil)
                is_lab = sub.is_lab
              end

              room_id = sub.subject_code[0..sub.subject_code.index('-')]

              temp_sub = Subject.new(sub.id,sub.subject_code,batch_list.count,emp_subject_list.count,sub.mg_course_id,sub.max_weekly_class,is_core,is_lab,sub.no_of_classes,room_id,batch_list.pluck(:id),Array.new)
              subject_stats[sub.id]=temp_sub

              #--------initiating Employee Stats
              active_subject_ids = MgSubject.where(:is_deleted=>0,:mg_school_id=>school_id).pluck(:id)
              curr_emp_subjects = MgEmployeeSubject.where(:mg_employee_id=>es.mg_employee_id,:mg_subject_id=>active_subject_ids)
              course_id_list = MgSubject.where(:is_deleted=>0,:mg_school_id=>school_id,:id=>curr_emp_subjects.pluck(:mg_subject_id)).pluck(:mg_course_id).uniq
              section_count = MgBatch.where(:is_deleted=>0,:mg_school_id=>school_id,:mg_course_id=>course_id_list).count
              emp = MgEmployee.find(es.mg_employee_id)

              temp_emp = Employee.new(es.mg_employee_id,curr_emp_subjects.count,section_count,course_id_list.count,emp.max_no_of_class,0,Marshal.load(Marshal.dump(emp_assignments)))
              employee_stats[es.mg_employee_id]= temp_emp

            end

        end


        batch_list.each do |batch|

          temp_section = Section.new(batch.id,course.id,batch.mg_employee_id,0,0,nil,nil)
          section_stats[batch.id]=temp_section

        end

        @all_emp_stats = @all_emp_stats.merge(employee_stats)
        @all_sub_stats = @all_sub_stats.merge(subject_stats)

         temp_class =Class.new(course.id,section_stats,subject_stats,employee_stats,total_classes,total_lectures)
        # puts ""
        # puts ""
        # puts ""
        # puts ""
        # puts "Class Stats"
        # puts temp_class.inspect
         class_stats[course.id]= temp_class


        if(total_classes>total_lectures && subject_stats.size>0)
          less_periods_classes+="#{course.course_name}, #{total_classes}, #{total_lectures}"
        end

        puts class_stats.inspect
        puts ""
     end


      if(less_periods_classes!="")
        return_msg +="\nTotal of max classes per week of all subjects is less than Total no of periods available for following classes  #{less_periods_classes}"

      end



      # puts "Array"
    # puts @sse_array.inspect
    # puts "Hash"
    # puts @sse_hash.inspect
    #
    # puts "pos 50"
    # puts @sse_array[50]
    # puts @sse_hash[50]

    generate_population(@sse_array,class_stats)


      puts "Subject Stats"
      puts  @all_sub_stats.inspect
      puts "Employee Stats"
      puts  @all_emp_stats.inspect

      puts "Before"






      if(return_msg == "")


        class_stats.each do |class_id,cl_st|
      sec_sts = cl_st['section_stats']
      sub_sts = cl_st['subject_stats']
      assigned_employees = Array.new

      #puts sec_sts.inspect




      #----------------Assigning Labs

      lab_subjects = sub_sts.select{|sub_id,sub| sub["is_lab"]}#==true }


      puts lab_subjects.inspect
      puts "lab subjects"

      sec_sts.each do |section_id,sec_st|

        (1..weekday_hash.length).each do |n|
        #puts lab_subjects.length
         # (1..lab_subjects.length).each do |n|

            assigned_lab = false

            lab_subjects.each do |lab_id,lab|

              period_count = lab.no_of_classes


              emp_id_list = MgEmployeeSubject.where(:is_deleted => 0,:mg_subject_id => lab_id).pluck(:mg_employee_id)

              lab_teacher_id = nil

              if(emp_id_list!=nil)
                if(emp_id_list.size>0)
                  lab_teacher_id = emp_id_list[0]
                end
              end


              period_indicies = [3,4]
              if(period_count ==1 )
                period_indicies = [3]
              elsif(period_count ==3 )
                period_indicies = [2,3,4]
              elsif(period_count >3 )
                period_indicies = [5,6,7,8]
              end


                     found_sub = false
                  @tt_entries.each do |curr_entry|
                    if( (curr_entry["mg_subject_id"]==lab_id) && (curr_entry["mg_batch_id"]==section_id) )
                      found_sub = true
                      break
                    end

                    #if((curr_entry["mg_weekday_id"]==n) && (curr_entry["mg_subject_id"]==lab_id) && ( period_indicies.include? curr_entry["mg_class_timings_id"]) )
                     if((curr_entry["mg_weekday_id"]==n) && (curr_entry["mg_room_id"]==lab.room_id) && ( period_indicies.include? curr_entry["mg_class_timings_id"]) )
                      found_sub = true
                      break
                    end
                  end

              if(lab_teacher_id!=nil && !found_sub)
                period_indicies.each do |period_num|

                  tt_entry =  Entry.new(n,period_num,section_id,lab_id,lab_teacher_id,school_id,lab.room_id)
                  @all_emp_stats[lab_teacher_id]["allotted_count"]+=1
                  @all_emp_stats[lab_teacher_id]["assignments"][n][period_num]=true
                  @tt_entries.push(tt_entry)
                end
                assigned_lab = true
                break

              end

              if(assigned_lab)
                break
              else

                period_indicies = [5,6]
                if(period_count ==1 )
                  period_indicies = [5]
                elsif(period_count ==3 )
                  period_indicies = [5,6,7]
                elsif(period_count >3 )
                  period_indicies = [5,6,7,8]
                end


                found_sub = false
                @tt_entries.each do |curr_entry|
                  if( (curr_entry["mg_subject_id"]==lab_id) && (curr_entry["mg_batch_id"]==section_id) )
                    found_sub = true
                    break
                  end

                  #if((curr_entry["mg_weekday_id"]==n) && (curr_entry["mg_subject_id"]==lab_id) && ( period_indicies.include? curr_entry["mg_class_timings_id"]) )
                  if((curr_entry["mg_weekday_id"]==n) && (curr_entry["mg_room_id"]==lab.room_id) && ( period_indicies.include? curr_entry["mg_class_timings_id"]) )
                    found_sub = true
                    break
                  end

                  if((curr_entry["mg_weekday_id"]==n) && (lab_subjects.keys.include? curr_entry["mg_subject_id"]) && (curr_entry["mg_batch_id"]==section_id)  )
                    found_sub = true
                    break
                  end
                end

                if(lab_teacher_id!=nil && !found_sub)
                  period_indicies.each do |period_num|

                    tt_entry =  Entry.new(n,period_num,section_id,lab_id,lab_teacher_id,school_id,lab.room_id)
                    @all_emp_stats[lab_teacher_id]["allotted_count"]+=1
                    @all_emp_stats[lab_teacher_id]["assignments"][n][period_num]=true
                    @tt_entries.push(tt_entry)
                  end
                  assigned_lab = true
                  break

                end

                if(assigned_lab)
                  break
                else

                end



              end

          end

        end

      end



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

            #puts @all_sub_stats[sub_id]["is_core_subject"]

           #if ((min_emp_count > emp_count) && (max_classes==6) && !found_sub)
            if ((min_emp_count > emp_count) && (@all_sub_stats[sub_id]["is_core_subject"]) && !found_sub)

             min_emp_sub_id = sub_id
             min_emp_count = emp_count
           end

          end

          period_index = 1
          (1..weekday_hash.length).each do |n|

             tt_entry =  Entry.new(n,period_index,section_id,min_emp_sub_id,class_teacher_id,school_id)
             @all_emp_stats[class_teacher_id]["allotted_count"]+=1
             @all_emp_stats[class_teacher_id]["assignments"][n][period_index]=true
             @tt_entries.push(tt_entry)
              # puts "Class Id = #{class_id}"
              # puts "Section Id = #{section_id}"
              # puts "Employee Id = #{class_teacher_id}"
              # puts "Subject Id = #{min_emp_sub_id}"
              #
              # puts ""
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

              #is_continuous = false

              if(start_index>2)
                if(@all_emp_stats[class_teacher_id]["assignments"][1][start_index-1] && @all_emp_stats[class_teacher_id]["assignments"][1][start_index-2])
                  found = true
                end
              end

              if(start_index<(weekday_hash[1]["timings"].length-2))
                if(@all_emp_stats[class_teacher_id]["assignments"][1][start_index+1] && @all_emp_stats[class_teacher_id]["assignments"][1][start_index+2])
                  found = true
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
            puts class_teacher_id

            if(start_index<=weekday_hash[1]["timings"].length && assigned_count<@all_emp_stats[class_teacher_id]["max_classes"])
              if(sec_id!=section_id)
                (1..weekday_hash.length).each do |n|
                  tt_entry =  Entry.new(n,start_index,sec_id,min_emp_sub_id,class_teacher_id,school_id)

                  @all_emp_stats[class_teacher_id]["allotted_count"]+=1
                  @all_emp_stats[class_teacher_id]["assignments"][n][start_index]=true
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

                    if(min_sub_emp_id==9)
                      puts "jayanth"
                    end

                    if(start_index>2)
                      if(@all_emp_stats[min_sub_emp_id]["assignments"][1][start_index-1] && @all_emp_stats[min_sub_emp_id]["assignments"][1][start_index-2])
                        found = true
                      end
                    end

                    if(start_index<(weekday_hash[1]["timings"].length-2))
                      if(@all_emp_stats[min_sub_emp_id]["assignments"][1][start_index+1] && @all_emp_stats[min_sub_emp_id]["assignments"][1][start_index+2])
                        found = true
                      end
                    end


                    if(found)
                      start_index+=1
                    else
                      break
                    end
                  end


                  if(start_index<=weekday_hash[1]["timings"].length && assigned_count<@all_emp_stats[min_sub_emp_id]["max_classes"])
                    assigned_count+=1
                      (1..weekday_hash.length).each do |n|
                      tt_entry =  Entry.new(n,start_index,sec_id,sub_id,min_sub_emp_id,school_id)

                      @all_emp_stats[min_sub_emp_id]["allotted_count"]+=1
                      @all_emp_stats[min_sub_emp_id]["assignments"][n][start_index]=true

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

                       # if(emp_id==9)
                       #   puts "Jayanth"
                       #   puts @all_emp_stats[emp_id]["max_classes"]
                       #   puts assigned_count
                       # end

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

                                    @all_emp_stats[emp_id]["allotted_count"]+=1
                                    @all_emp_stats[emp_id]["assignments"][n][curr_period]=true

                                    @tt_entries.push(tt_entry)
                                 end
                                 break
                               end

                             end


                             if(free_period)
                               break
                             else
                               #puts "not Assigned subject =#{sub_id} and batch = #{sec_id} "
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

      puts  @tt_entries.inspect
      puts ""


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
            if(!@all_sub_stats[sub_id]["is_core_subject"] && !@all_sub_stats[sub_id]["is_lab"])
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

                              @all_emp_stats[emp_id]["allotted_count"]+=1
                              @all_emp_stats[emp_id]["assignments"][n][curr_period]=true

                              @tt_entries.push(tt_entry)
                            #end
                            break
                          end

                        end

                        #puts "n = #{n}"
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


      # puts "Subject Stats"
      # puts  @all_sub_stats.inspect
      #puts "Employee Stats"
      #puts  @all_emp_stats.inspect

      #puts "After"

    # puts  @tt_entries.inspect
    # puts ""

      #-------------Inserting to database

        academic_years  =   MgTimeTable.where("start_date < \"#{Date.today}\" && \"#{Date.today}\" < end_date").where(:is_deleted=>0,:mg_school_id=>school_id).pluck(:id)

        time_table_id = academic_years[0]

      MgTimeTableEntry.delete_all(:mg_school_id=>school_id,:mg_timetable_id=>time_table_id)

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
        time_table_entry.mg_timetable_id=time_table_id
        time_table_entry.mg_school_id=curr_entry['mg_school_id']
        time_table_entry.is_deleted=0

        if timing != nil
          time_table_entry.mg_class_timings_id=timing.id
          time_table_entry.save
        end

      end

      return_msg = "Time table has been generated";

    end #time table created


      puts "Timetable Created"

      return return_msg
  end

  def generate_population(sse,class_stats)
    puts "Population Start"

    puts "Population End"
  end


end