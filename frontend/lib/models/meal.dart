class Meal {
  int? meal_id;
  final int? total_calories;
  final int? total_protein;
  final int? total_sugar;
  final String meal_name;
  List<dynamic>? meal_components;
  final bool meal_isConsumed;

  Meal({
    required this.meal_name,
    required this.meal_isConsumed,
    this.meal_id,
    this.meal_components,
    this.total_calories,
    this.total_protein,
    this.total_sugar,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
        meal_id: json['meal_id'] as int,
        total_calories: json['total_calories'] as int,
        total_protein: json['total_protein'] as int,
        total_sugar: json['total_sugar'] as int,
        meal_name: json['meal_name'] as String,
        meal_isConsumed: json['meal_isConsumed'] as bool,
        meal_components: json['meal_components']);
  }
  dynamic toJson() => {
        'meal_id': meal_id,
        'meal_name': meal_name,
        'meal_isConsumed': meal_isConsumed,
        'meal_components': meal_components
      };
}

class MealSchedule {
  int? mealschedule_id;
  final int meal;
  final int mealplan;
  final int day;
  final String meal_type;

  MealSchedule(
      {required this.meal,
      required this.mealplan,
      required this.day,
      required this.meal_type,
      this.mealschedule_id});

  factory MealSchedule.fromJson(Map<String, dynamic> json) {
    return MealSchedule(
        mealschedule_id: json['mealschedule_id'] as int,
        meal: json['meal'] as int,
        mealplan: json['mealplan'] as int,
        day: json['day'] as int,
        meal_type: json['meal_type']);
  }
  dynamic toJson() => {
        'mealschedule_id': mealschedule_id,
        'meal': meal,
        'mealplan': mealplan,
        'day': day,
        'meal_type': meal_type,
      };
}

class MealDay {
  int? mealday_id;
  final DateTime trip_day;
  final int trip;
  final int? daily_caloric_scheduled;
  final int? daily_protein_scheduled;
  final int? daily_sugar_scheduled;

  MealDay(
      {required this.trip_day,
      required this.trip,
      required this.daily_caloric_scheduled,
      required this.daily_protein_scheduled,
      required this.daily_sugar_scheduled,
      this.mealday_id});

  factory MealDay.fromJson(Map<String, dynamic> json) {
    return MealDay(
        mealday_id: json['mealday_id'],
        trip: json['trip'],
        daily_caloric_scheduled: json['daily_caloric_scheduled'],
        daily_protein_scheduled: json['daily_protein_scheduled'],
        daily_sugar_scheduled: json['daily_sugar_scheduled'],
        trip_day: DateTime.parse(json['trip_day'].toString()));
  }
  dynamic toJson() => {
        'mealday_id': mealday_id,
        'trip': trip,
        'daily_caloric_scheduled': daily_caloric_scheduled,
        'daily_protein_scheduled': daily_protein_scheduled,
        'daily_sugar_scheduled': daily_sugar_scheduled,
        'trip_day': trip_day,
      };
}

class MealPlan {
  int? mealplan_id;
  final int mealplan_hiker;
  final List<dynamic> mealplan_meals;
  final int mealplan_trip;
  final int total_trip_calories;
  final int est_daily_minimum_cal_required;

  MealPlan(
      {required this.mealplan_hiker,
      required this.mealplan_meals,
      required this.mealplan_trip,
      required this.total_trip_calories,
      required this.est_daily_minimum_cal_required,
      this.mealplan_id});

  factory MealPlan.fromJson(Map<String, dynamic> json) {
    return MealPlan(
        mealplan_id: json['mealplan_id'] as int,
        mealplan_hiker: json['mealplan_hiker'] as int,
        mealplan_meals: json['mealplan_meals'],
        mealplan_trip: json['mealplan_trip'] as int,
        total_trip_calories: json['total_trip_calories'] as int,
        est_daily_minimum_cal_required:
            json['est_daily_minimum_cal_required'] as int);
  }
  dynamic toJson() => {
        'mealplan_id': mealplan_id,
        'mealplan_hiker': mealplan_hiker,
        'mealplan_meals': mealplan_meals,
        'mealplan_trip': mealplan_trip,
        'total_trip_calories': total_trip_calories,
        'est_daily_minimum_cal_required': est_daily_minimum_cal_required,
      };
}
