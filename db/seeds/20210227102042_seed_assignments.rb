# frozen_string_literal: true

def seed_assignments
  25.times do |_|
    break if Assignment.count >= 25

    reviewer, reviewee = Employee.order('RAND()').take(2)
    next if Assignment.pending.exists?(reviewer: reviewer, reviewee: reviewee)

    Assignment.create!(
      creator_id: 1,
      reviewer:   reviewer,
      reviewee:   reviewee
    )
  end

  seed_assignments if Assignment.count < 25
end

seed_assignments
