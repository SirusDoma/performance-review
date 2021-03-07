# frozen_string_literal: true

require_relative 'main'

use AuthController
use EmployeeController
use QuestionController
use AssignmentController
use ReviewController
run PerformanceReview
