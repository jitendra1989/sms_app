class AddIsTransferCertificateProducedToMgPreviousEducations < ActiveRecord::Migration
  def change
  	add_column :mg_previous_educations, :is_transfer_certificate_produced, :boolean
  end
end
