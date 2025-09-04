// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../chat/chat_list_screen.dart';
//
// class ChatNotificationBadge extends StatelessWidget {
//   final VoidCallback? onTap;
//   final double size;
//   final Color backgroundColor;
//   final Color textColor;
//
//   const ChatNotificationBadge({
//     Key? key,
//     this.onTap,
//     this.size = 20,
//     this.backgroundColor = Colors.red,
//     this.textColor = Colors.white,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: _getUnreadMessagesStream(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return SizedBox(
//             width: size,
//             height: size,
//             child: const CircularProgressIndicator(strokeWidth: 2),
//           );
//         }
//
//         final unreadCount = _calculateTotalUnreadCount(snapshot.data?.docs ?? []);
//
//         if (unreadCount == 0) {
//           return const SizedBox.shrink();
//         }
//
//         return GestureDetector(
//           onTap: onTap ?? () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const ChatListScreen()),
//             );
//           },
//           child: Container(
//             width: size,
//             height: size,
//             decoration: BoxDecoration(
//               color: backgroundColor,
//               shape: BoxShape.circle,
//             ),
//             child: Center(
//               child: Text(
//                 unreadCount > 99 ? '99+' : unreadCount.toString(),
//                 style: TextStyle(
//                   color: textColor,
//                   fontSize: size * 0.4,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Stream<QuerySnapshot> _getUnreadMessagesStream() {
//     final currentUserId = FirebaseAuth.instance.currentUser?.uid;
//     if (currentUserId == null) {
//       return Stream.value(QuerySnapshot.withConverter(
//         converter: (doc, options) => doc,
//         docs: [],
//         metadata: SnapshotMetadata(hasPendingWrites: false, isFromCache: false),
//       ));
//     }
//
//     return FirebaseFirestore.instance
//         .collection('chatRooms')
//         .where('participant1Id', isEqualTo: currentUserId)
//         .snapshots()
//         .asyncMap((snapshot1) async {
//       final rooms1 = snapshot1.docs;
//
//       final snapshot2 = await FirebaseFirestore.instance
//           .collection('chatRooms')
//           .where('participant2Id', isEqualTo: currentUserId)
//           .get();
//
//       final rooms2 = snapshot2.docs;
//       final allRooms = [...rooms1, ...rooms2];
//
//       return QuerySnapshot.withConverter(
//         converter: (doc, options) => doc,
//         docs: allRooms,
//         metadata: SnapshotMetadata(hasPendingWrites: false, isFromCache: false),
//       );
//     });
//   }
//
//   int _calculateTotalUnreadCount(List<QueryDocumentSnapshot> chatRooms) {
//     int totalUnread = 0;
//     for (final room in chatRooms) {
//       final data = room.data() as Map<String, dynamic>;
//       totalUnread += data['unreadCount'] ?? 0;
//     }
//     return totalUnread;
//   }
// }

