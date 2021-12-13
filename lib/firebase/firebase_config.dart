import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OutFittedApp {
  static const String appName = 'OutFitted';

  static SharedPreferences sharedPreferences;

  static User firebaseUser;
  static FirebaseAuth auth;
  static FirebaseFirestore firestore;

  // firestore collections
  static final String collectionProduct = 'products';
  static final String collectionCategory = 'categories';
  static final String collectionCustomer = 'customers';
  static final String collectionOrders = 'orders';
  static final String customerCartList = 'customerCart';
  static final String customerWishList = 'customerWishList';
  static final String subCollectionAddress = 'customerAddress';

  static final String customerName = 'name';
  static final String customerEmail = 'email';
  static final String customerPhotoUrl = 'photoUrl';
  static final String customerUID = 'uid';
  static final String customerAvatarUrl = 'url';

  static final String addressID = 'addressID';
  static final String totalAmount = 'totalAmount';
  static final String productID = 'OrderedProductIDs';
  static final String paymentDetails = 'paymentDetails';
  static final String orderTime = 'orderTime';
  static final String isSuccess = 'isSuccess';
  static final String orderStatus = 'orderStatus';
}
