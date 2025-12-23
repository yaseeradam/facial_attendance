class Teacher {
  final int id;
  final String teacherId;
  final String fullName;
  final String email;
  final String role;
  final DateTime createdAt;

  Teacher({
    required this.id,
    required this.teacherId,
    required this.fullName,
    required this.email,
    required this.role,
    required this.createdAt,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      teacherId: json['teacher_id'],
      fullName: json['full_name'],
      email: json['email'],
      role: json['role'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'teacher_id': teacherId,
      'full_name': fullName,
      'email': email,
      'role': role,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class ClassModel {
  final int id;
  final String className;
  final String classCode;
  final int teacherId;
  final DateTime createdAt;
  final Teacher? teacher;

  ClassModel({
    required this.id,
    required this.className,
    required this.classCode,
    required this.teacherId,
    required this.createdAt,
    this.teacher,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'],
      className: json['class_name'],
      classCode: json['class_code'],
      teacherId: json['teacher_id'],
      createdAt: DateTime.parse(json['created_at']),
      teacher: json['teacher'] != null ? Teacher.fromJson(json['teacher']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'class_name': className,
      'class_code': classCode,
      'teacher_id': teacherId,
      'created_at': createdAt.toIso8601String(),
      'teacher': teacher?.toJson(),
    };
  }
}

class Student {
  final int id;
  final String studentId;
  final String fullName;
  final int classId;
  final bool faceEnrolled;
  final DateTime createdAt;
  final String? className;

  Student({
    required this.id,
    required this.studentId,
    required this.fullName,
    required this.classId,
    required this.faceEnrolled,
    required this.createdAt,
    this.className,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      studentId: json['student_id'],
      fullName: json['full_name'],
      classId: json['class_id'],
      faceEnrolled: json['face_enrolled'],
      createdAt: DateTime.parse(json['created_at']),
      className: json['class_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'full_name': fullName,
      'class_id': classId,
      'face_enrolled': faceEnrolled,
      'created_at': createdAt.toIso8601String(),
      'class_name': className,
    };
  }
}

class Attendance {
  final int id;
  final int studentId;
  final int classId;
  final DateTime markedAt;
  final double? confidenceScore;
  final String? studentName;
  final String? studentStudentId;
  final String? className;

  Attendance({
    required this.id,
    required this.studentId,
    required this.classId,
    required this.markedAt,
    this.confidenceScore,
    this.studentName,
    this.studentStudentId,
    this.className,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'],
      studentId: json['student_id'],
      classId: json['class_id'],
      markedAt: DateTime.parse(json['marked_at']),
      confidenceScore: json['confidence_score']?.toDouble(),
      studentName: json['student_name'],
      studentStudentId: json['student_student_id'],
      className: json['class_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'class_id': classId,
      'marked_at': markedAt.toIso8601String(),
      'confidence_score': confidenceScore,
      'student_name': studentName,
      'student_student_id': studentStudentId,
      'class_name': className,
    };
  }
}

class AttendanceSummary {
  final int totalStudents;
  final int presentStudents;
  final double attendanceRate;
  final DateTime date;

  AttendanceSummary({
    required this.totalStudents,
    required this.presentStudents,
    required this.attendanceRate,
    required this.date,
  });

  factory AttendanceSummary.fromJson(Map<String, dynamic> json) {
    return AttendanceSummary(
      totalStudents: json['total_students'],
      presentStudents: json['present_students'],
      attendanceRate: json['attendance_rate'].toDouble(),
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_students': totalStudents,
      'present_students': presentStudents,
      'attendance_rate': attendanceRate,
      'date': date.toIso8601String(),
    };
  }
}