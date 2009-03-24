namespace :audit do
  desc 'Finds ActiveRecord classes without attr_accessible'
  task :mass_assignment => :environment do
    puts "Audit mass assignment in models:"
    Dir.glob(RAILS_ROOT + '/app/models/**/*.rb').each { |file| require file }
    class_count, results, failures = AuditMassAssignment.audit_all
    putc results
    putc "\n"
    putc "\n"
    if failures.size > 0
      count = 0
      for failure in failures
        count += 1
        puts "  "+count.to_s+") "+failure.name
      end
      putc "\n"
      puts "  Solution: use attr_accessible in these models"
      putc "\n"
    end
    puts class_count.to_s+" models, "+failures.size.to_s+" failures"
  end
end