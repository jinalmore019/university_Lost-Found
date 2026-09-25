import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String name;
  final String email;
  final String phone;
  final String role; // 'user' or 'admin'
  final DateTime createdAt;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      userId: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      role: map['role'] ?? 'user',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

class LostItem {
  final String itemId;
  final String ownerId;
  final String itemName;
  final String category;
  final String description;
  final String color;
  final String location;
  final DateTime lostDate;
  final String imageUrl;
  final String status; // 'LOST', 'RETURNED', 'CLOSED'

  LostItem({
    required this.itemId,
    required this.ownerId,
    required this.itemName,
    required this.category,
    required this.description,
    required this.color,
    required this.location,
    required this.lostDate,
    required this.imageUrl,
    required this.status,
  });

  factory LostItem.fromMap(Map<String, dynamic> map, String id) {
    return LostItem(
      itemId: id,
      ownerId: map['ownerId'] ?? '',
      itemName: map['itemName'] ?? '',
      category: map['category'] ?? '',
      description: map['description'] ?? '',
      color: map['color'] ?? '',
      location: map['location'] ?? '',
      lostDate: (map['lostDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      imageUrl: map['imageUrl'] ?? '',
      status: map['status'] ?? 'LOST',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId,
      'itemName': itemName,
      'category': category,
      'description': description,
      'color': color,
      'location': location,
      'lostDate': Timestamp.fromDate(lostDate),
      'imageUrl': imageUrl,
      'status': status,
    };
  }
}

class FoundItem {
  final String itemId;
  final String finderId;
  final String category;
  final String location;
  final DateTime foundDate;
  final String publicDescription;
  final String imageUrl;
  final String status; // 'FOUND', 'CLAIM_PENDING', 'VERIFICATION', 'HANDOVER_PENDING', 'RETURNED'
  final List<VerificationQuestion> verificationQuestions;

  FoundItem({
    required this.itemId,
    required this.finderId,
    required this.category,
    required this.location,
    required this.foundDate,
    required this.publicDescription,
    required this.imageUrl,
    required this.status,
    required this.verificationQuestions,
  });

  factory FoundItem.fromMap(Map<String, dynamic> map, String id) {
    var qs = map['verificationQuestions'] as List? ?? [];
    return FoundItem(
      itemId: id,
      finderId: map['finderId'] ?? '',
      category: map['category'] ?? '',
      location: map['location'] ?? '',
      foundDate: (map['foundDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      publicDescription: map['publicDescription'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      status: map['status'] ?? 'FOUND',
      verificationQuestions: qs.map((q) => VerificationQuestion.fromMap(q)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'finderId': finderId,
      'category': category,
      'location': location,
      'foundDate': Timestamp.fromDate(foundDate),
      'publicDescription': publicDescription,
      'imageUrl': imageUrl,
      'status': status,
      'verificationQuestions': verificationQuestions.map((q) => q.toMap()).toList(),
    };
  }
}

class VerificationQuestion {
  final String question;
  final String answer; // Only visible to finder/admin

  VerificationQuestion({required this.question, required this.answer});

  factory VerificationQuestion.fromMap(Map<String, dynamic> map) {
    return VerificationQuestion(
      question: map['question'] ?? '',
      answer: map['answer'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answer': answer,
    };
  }
}

class Claim {
  final String claimId;
  final String itemId;
  final String claimantId;
  final String finderId;
  final List<String> answers; // Answers provided by claimant
  final String status; // 'PENDING', 'APPROVED', 'REJECTED'
  final bool contactShared;
  final bool finderHandoverConfirm;
  final bool claimantHandoverConfirm;
  final DateTime createdAt;

  Claim({
    required this.claimId,
    required this.itemId,
    required this.claimantId,
    required this.finderId,
    required this.answers,
    required this.status,
    required this.contactShared,
    required this.finderHandoverConfirm,
    required this.claimantHandoverConfirm,
    required this.createdAt,
  });

  factory Claim.fromMap(Map<String, dynamic> map, String id) {
    return Claim(
      claimId: id,
      itemId: map['itemId'] ?? '',
      claimantId: map['claimantId'] ?? '',
      finderId: map['finderId'] ?? '',
      answers: List<String>.from(map['answers'] ?? []),
      status: map['status'] ?? 'PENDING',
      contactShared: map['contactShared'] ?? false,
      finderHandoverConfirm: map['finderHandoverConfirm'] ?? false,
      claimantHandoverConfirm: map['claimantHandoverConfirm'] ?? false,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'claimantId': claimantId,
      'finderId': finderId,
      'answers': answers,
      'status': status,
      'contactShared': contactShared,
      'finderHandoverConfirm': finderHandoverConfirm,
      'claimantHandoverConfirm': claimantHandoverConfirm,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
