import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat2/bloc/blocs.dart';
import 'package:chat2/data/models/featured_product_model.dart';
import 'package:chat2/data/models/models.dart';
import 'package:intl/intl.dart';

import '../models/likes_model.dart';
import '../models/log_model.dart';

class Repository {

  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore;

  Repository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<void> verifyPhone({
    required String phoneNumber,
    required Function(PhoneAuthCredential) verificationCompleted,
    required Function(FirebaseAuthException) verificationFailed,
    required Function(String, int?) codeSent,
    required Function(String) codeAutoRetrievalTimeout,
  }) async {
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  //adBanner  Repository
  Stream<List<AdBanner>> getAllAdBanner() {
    return _firebaseFirestore.collection('banners').snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => AdBanner.fromSnapShot(doc)).toList());
  }

//product Repository
  Stream<List<Product>> getAllProducts() {
    return _firebaseFirestore
        .collection('products')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map<Product>((doc) => Product.fromSnapShot(doc))
          .toList();
    });
  }

  // featured product Repository
  Future<List<FeaturedProduct>> getFeaturedProducts() {
    return _firebaseFirestore
        .collection('featured_products')
        .get()
        .then((snapshot) {
      return snapshot.docs
          .map<FeaturedProduct>((doc) => FeaturedProduct.fromSnapShot(doc))
          .toList();
    });
  }

  Stream<List<Product>> getRelatedProducts(String category, String id) {
    return _firebaseFirestore
        .collection('products')
        .where('category', isEqualTo: category)
        .where('productId', isNotEqualTo: id)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map<Product>((doc) => Product.fromSnapShot(doc))
          .toList();
    });
  }

  Stream<List<Product>> getSellerProducts(String sellerId) {
    return _firebaseFirestore
        .collection('products')
        .where('sellerId', isEqualTo: sellerId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map<Product>((doc) => Product.fromSnapShot(doc))
          .toList();
    });
  }

  Future<void> deleteProduct(String productId) async {
    await _firebaseFirestore.collection('products').doc(productId).delete();
  }

  Future<void> changeProductStatus(String id, String status) async {
    await _firebaseFirestore.collection('products').doc(id).update({
      'productStatus': status,
    });
  }

  //Reviews Repository
  Stream<List<Review>> getAllReviews(
    String objectId,
    String reviewType,
  ) {
    return _firebaseFirestore
        .collection('reviews')
        .where("objectId", isEqualTo: objectId)
        .where("reviewType", isEqualTo: reviewType)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map<Review>((doc) => Review.fromSnapShot(doc))
          .toList();
    });
  }

  //find customer by phone number
  Future<Customer?> findBuyerByPhoneNumber(String? phoneNumber) async {
    return _firebaseFirestore
        .collection('users')
        .where('Phonenumber', isEqualTo: phoneNumber)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isEmpty) {
        return null;
      }
      return Customer.fromSnapshot(snapshot.docs.first);
    });
  }

  Future<void> createBuyer(
      String? id, String? phone, String name, String imageUrl) async {
    await _firebaseFirestore.collection('users').doc(id).set({
      'userID': id,
      'phoneNumber': phone,
      'userRole': 'buyer',
      'fullName': name,
      'imageUrl': imageUrl,
      'userStatus': 'active',
      'dateAdded': DateFormat('yyyy-MM-ddThh:mm:ss').format(DateTime.now())
    });
  }

  Future<void> updateShopInfo(String id, String name, String location, String paymentMethod, String imageUrl) async {
    await _firebaseFirestore.collection('users').doc(id).update({
      'ShopName': name,
      'coverImage': imageUrl,
      'ShopLocation' : location,
      'aboutshop': paymentMethod
    });
  }

  Future<void> updateUserInfo(String id, String name, String imageUrl) async {
    await _firebaseFirestore.collection('users').doc(id).update({
      'fullName': name,
      'imageUrl': imageUrl,
    });
  }

  Future<void> updateSellerPhoneNumber(String id, String number) async {
    await _firebaseFirestore.collection('sellers').doc(id).update({
      'phoneNumber': number,
    });
  }

  Future<void> updateBuyerPhoneNumber(String id, String number) async {
    await _firebaseFirestore.collection('users').doc(id).update({
      'phoneNumber': number,
    });
  }

  // Seller Repository
  Stream<List<Seller>> getAllSellers() {
    return _firebaseFirestore.collection('sellers')
        .snapshots().map((snapshot) {
      return snapshot.docs
          .map<Seller>((doc) => Seller.fromSnapShot(doc))
          .toList();
    });
  }

  Future<Seller> getSellerById(String sellerId) {
    return _firebaseFirestore
        .collection('sellers')
        .doc(sellerId)
        .get()
        .then((snapshot) {
      return Seller.fromSnapShot(snapshot);
    });
  }

  Future<Seller?> findSellerByPhoneNumber(String? phoneNumber) async {
    return _firebaseFirestore
        .collection('users')
        .where('Phonenumber', isEqualTo: phoneNumber)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isEmpty) {
        return null;
      }
      return Seller.fromSnapShot(snapshot.docs.first);
    });
  }

  Future<Follows?> findFollower(String? sellerId, String? buyerId) async {
    return _firebaseFirestore
        .collection('follows')
        .where('sellerId', isEqualTo: sellerId)
        .where('buyerId', isEqualTo: buyerId)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isEmpty) {
        return null;
      }
      return Follows.fromSnapShot(snapshot.docs.first);
    });
  }

  Future<Likes?> findLike(String? userId, String objectId) async {
    return _firebaseFirestore
        .collection('likes')
        .where('userId', isEqualTo: userId)
        .where('objectId', isEqualTo: objectId)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isEmpty) {
        return null;
      }
      return Likes.fromSnapShot(snapshot.docs.first);
    });
  }

  Future<void> unLike(String likeId) async {
    await _firebaseFirestore.collection('likes').doc(likeId).delete();
  }

  Future<List<Likes>> getAllLikes() {
    return _firebaseFirestore
        .collection('likes')
        //.where('objectId', isEqualTo: objectId)
        .get()
        .then((snapshot) {
      return snapshot.docs
          .map<Likes>((doc) => Likes.fromSnapShot(doc))
          .toList();
    });
  }

  Future<void> addLike(String id, String userId, String objectId) async {
    await _firebaseFirestore.collection('likes').doc(id).set({
      'userId': userId,
      'objectId': objectId,
      'likeId': id,
      'dateAdded': DateFormat('yyyy-MM-ddThh:mm:ss').format(DateTime.now())
    });
  }

  Future<void> createFollower(String? id, String? buyerId, String? sellerId) async {
    await _firebaseFirestore.collection('follows').doc(id).set({
      'followId': id,
      'buyerId': buyerId,
      'sellerId': sellerId,
      'createdAt': DateFormat('yyyy-MM-ddThh:mm:ss').format(DateTime.now())
    });
  }

  Future<void> unFollow(String followId) async {
    await _firebaseFirestore.collection('follows').doc(followId).delete();
  }

  Future<List<Customer>> getAllUsers() {
    return _firebaseFirestore
        .collection('users')
        .where('userRole', isEqualTo: "buyer")
        .get()
        .then((snapshot) {
      return snapshot.docs
          .map<Customer>((doc) => Customer.fromSnapshot(doc))
          .toList();
    });
  }

  Future<List<Seller>> getSellers() {
    return _firebaseFirestore
        .collection('sellers')
        .get()
        .then((snapshot) {
      return snapshot.docs
          .map<Seller>((doc) => Seller.fromSnapShot(doc))
          .toList();
    });
  }

  Future<List<Log>> getShopVisits(String sellerId) {
    return _firebaseFirestore
        .collection('logs')
        .where('logType', isEqualTo: "shopVisit")
        .where('sellerId', isEqualTo: sellerId)
        .get()
        .then((snapshot) {
      return snapshot.docs
          .map<Log>((doc) => Log.fromSnapshot(doc))
          .toList();
    });
  }

  Future<void> addLog(String? id, String? buyerId, String? sellerId, String logType) async {
    await _firebaseFirestore.collection('logs').doc(id).set({
      'logID': id,
      'buyerId': buyerId,
      'sellerId': sellerId,
      'logType': logType,
      'date': DateFormat('yyyy-MM-ddThh:mm:ss').format(DateTime.now())
    });
  }

  //Follows Repository
  Stream<List<Follows>> getAllFollows(String sellerId) {
    return _firebaseFirestore
        .collection('follows')
        .where('sellerId', isEqualTo: sellerId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map<Follows>((doc) => Follows.fromSnapShot(doc))
          .toList();
    });
  }

  //Message Repository
  Stream<List<Message>> getAllMessages(String chatId) {
    return _firebaseFirestore
        .collection('messages')
        .where('chatId', isEqualTo: chatId)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map<Message>((doc) => Message.fromSnapShot(doc))
          .toList();
    });
  }

  Future<ChatRoom?> findChat(String? userId, String sellerId) async {
    return _firebaseFirestore
        .collection('chat_rooms')
        .where('from', isEqualTo: userId)
        .where('to', isEqualTo: sellerId)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isEmpty) {
        return null;
      }
      return ChatRoom.fromSnapShot(snapshot.docs.first);
    });
  }

  Future<void> createChat(String? id, String name, String imageUrl, String? buyerId, String? sellerId) async {
    await _firebaseFirestore.collection('chat_rooms').doc(id).set({
      'chatId': id,
      'name': name,
      'from': buyerId,
      'imageUrl': imageUrl,
      'to': sellerId,
      'dateAdded': DateFormat('yyyy-MM-ddThh:mm:ss').format(DateTime.now()),
      'lastMessage':'',
      'lastMessageTime': Timestamp.now()
    });
  }

// Address Repository
  Stream<List<Address>> getAllAddresses(String userId) {
    return _firebaseFirestore
        .collection('addresses')

        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map<Address>((doc) => Address.fromSnapShot(doc))
          .toList();
    });
  }

  Stream<Address> getAddressById(String addressId) {
    return _firebaseFirestore
        .collection('addresses')
        .doc(addressId)
        .snapshots()
        .map((snapshot) => Address.fromSnapShot(snapshot));
  }

  //order Repository
  Stream<List<Order>> getAllOrders() {
    return _firebaseFirestore
        .collection('orders')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map<Order>((doc) => Order.fromSnapshot(doc))
          .toList();
    });
  }

  //order Repository

  Stream<List<Order>> getSellerOrders(String sellerId) {
    return _firebaseFirestore
        .collection('orders')
        .where('sellerId', isEqualTo: sellerId)
        .where('orderStatus', whereIn: ["pending", "paid"])
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map<Order>((doc) => Order.fromSnapshot(doc))
          .toList();
    });
  }

  Stream<List<Order>> getAllSellerOrders(String sellerId) {
    return _firebaseFirestore
        .collection('orders')
        .where('sellerId', isEqualTo: sellerId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map<Order>((doc) => Order.fromSnapshot(doc))
          .toList();
    });
  }

  Stream<List<Order>> getBuyerOrders(String buyerId) {
    return _firebaseFirestore
        .collection('orders')
        .where('orderStatus', whereIn: ["pending", "paid"])
        .where('buyerId', isEqualTo: buyerId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map<Order>((doc) => Order.fromSnapshot(doc))
          .toList();
    });
  }

  Future<void> changeOrderStatus(String id, String status) async {
    await _firebaseFirestore.collection('orders').doc(id).update({
      'orderStatus': status,
    });
  }

  Future<Order?> getOrder(String? id) async {
    return _firebaseFirestore
        .collection('orders')
        .where('orderId', isEqualTo: id)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isEmpty) {
        return null;
      }
      return Order.fromSnapshot(snapshot.docs.first);
    });
  }

  Stream<List<Order>> getPurchaseOrder(String sellerId) {
    return _firebaseFirestore
        .collection('orders')
        .where('buyerId', isEqualTo: sellerId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map<Order>((doc) => Order.fromSnapshot(doc))
          .toList();
    });
  }

  Stream<List<Order>> getBuyerPurchases(String buyerId) {
    return _firebaseFirestore
        .collection('orders')
        .where('buyerId', isEqualTo: buyerId)
        .where('orderStatus', whereIn: ["completed", "delivered", "paid"])
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map<Order>((doc) => Order.fromSnapshot(doc))
          .toList();
    });
  }

  Stream<List<Order>> getOrderById(String id) {
    return _firebaseFirestore
        .collection('orders')
        .where('orderId', isEqualTo: id)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map<Order>((doc) => Order.fromSnapshot(doc))
          .toList();
    });
  }

//chat Repository
  Stream<List<ChatRoom>> getAllChats(String userId) {
    return _firebaseFirestore
        .collection('chat_rooms')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map<ChatRoom>((doc) => ChatRoom.fromSnapShot(doc))
          .toList().where((element) => (element.to == userId || element.from == userId)).toList();
    });
  }

  Stream<List<CategoryProduct>> getAllCategories() {
    return _firebaseFirestore
        .collection('categories')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map<CategoryProduct>((doc) => CategoryProduct.fromSnapshot(doc))
          .toList();
    });
  }
}
