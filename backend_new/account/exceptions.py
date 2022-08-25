from rest_framework.exceptions import APIException

class StartDateConflict(APIException):
    status_code = 400
    default_detail = "Start date conflicts with an existing trip's dates"
    default_code = "start_date_conflict"

class EndDateConflict(APIException):
    status_code = 400
    default_detail = "End date conflicts with an existing trip's dates"
    default_code = "end_date_conflict"

class ExistingTripConflict(APIException):
    status_code = 400
    default_detail = "An existing trip's start and end dates fall within the proposed trip date range"
    default_code = "existing_trip_conflict"

class StartDatePastConflict(APIException):
    status_code = 452
    default_detail = "Start date cannot be in the past"
    default_code = "start_date_past_conflict"

class TripDurationConflict(APIException):
    status_code = 400
    default_detail = "Time difference between start and end dates must be more than 30 minutes"
    default_code = "trip_duration_conflict"

class EndDateFutureConflict(APIException):
    status_code = 400
    default_detail = "Trip cannot be scheduled to end more than 5 years in the future"
    default_code = "end_date_future_conflict"

class StartEndDateConflict(APIException):
    status_code = 400
    default_detail = "Start and end dates fall within an existing trip's date range"
    default_code = "start_end_date_conflict"