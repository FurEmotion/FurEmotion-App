import 'package:babystory/apis/user_api.dart';
import 'package:babystory/error/error.dart';
import 'package:babystory/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  final firebase.FirebaseAuth _firebaseAuth = firebase.FirebaseAuth.instance;
  final UserApi _userApi = UserApi();
  late firebase.User? _user;
  late User? _myUser;

  firebase.User? get firebaseUser => _user;
  User? get user => _myUser;

  Future<User?> getUser() async {
    firebase.User? user = _firebaseAuth.currentUser;
    if (user == null) {
      await signOut();
      return null;
    }
    var myUser = await _userApi.login(uid: user.uid, email: user.email!);
    if (myUser == null) {
      await signOut();
      return null;
    }
    _myUser = myUser;
    myUser.printInfo();

    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('x-jwt', myUser.jwt!);

    return myUser;
  }

  Future<AuthError?> signupWithEmailAndPassword({
    required String email,
    required String nickname,
    required String password,
  }) async {
    try {
      firebase.UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        _user = credential.user!;

        var myUser = await _userApi.login(
            uid: credential.user!.uid, email: credential.user!.email!);
        if (myUser == null) {
          await signOut();
          return null;
        }
        _myUser = myUser;
        myUser.printInfo();

        return null;
      }
      return AuthError(
          message: 'Server Error', type: ErrorType.auth, code: 'server-error');
    } on firebase.FirebaseAuthException catch (error) {
      AuthError authError = AuthError(
        message:
            AuthError.getFirebaseAuthError(error.code) ?? 'firebase auth error',
        type: ErrorType.auth,
        code: error.code,
      );
      return authError;
    }
  }

  Future<AuthError?> signinWithGoogle({isLogin = false}) async {
    print("SigninWithGoogle, isLogin: $isLogin");
    GoogleSignIn googleSignIn = GoogleSignIn();
    print('googleSignIn: $googleSignIn');
    GoogleSignInAccount? account;
    try {
      account = await googleSignIn.signIn();
    } catch (e) {
      print("Error on googleSignIn: $e");
    }
    print('account: $account');
    if (account != null) {
      GoogleSignInAuthentication authentication = await account.authentication;
      firebase.OAuthCredential googleCredential =
          firebase.GoogleAuthProvider.credential(
        idToken: authentication.idToken,
        accessToken: authentication.accessToken,
      );
      firebase.UserCredential credential =
          await _firebaseAuth.signInWithCredential(googleCredential);
      print("credential: ${credential.user}");
      if (credential.user != null) {
        _user = credential.user!;
        print(isLogin ? "request login" : "request create user");
        var myUser = isLogin
            ? await _userApi.login(
                uid: credential.user!.uid, email: credential.user!.email!)
            : await _userApi.createUser(
                user: User(
                uid: credential.user!.uid,
                email: credential.user!.email!,
                nickname: credential.user!.displayName!,
                photoId: credential.user!.photoURL,
              ));
        myUser?.printInfo();
        if (myUser == null) {
          await signOut();
          return null;
        }
        _myUser = myUser;
        myUser.printInfo();

        return null;
      }
      return AuthError(
          code: 'google-user-not-found',
          type: ErrorType.auth,
          message: 'firebase.User not found');
    }
    return AuthError(
        message: 'Account not found',
        type: ErrorType.auth,
        code: 'account-not-found');
  }

  Future<AuthError?> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      firebase.UserCredential credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        _user = credential.user!;

        var myUser = await _userApi.login(
            uid: credential.user!.uid, email: credential.user!.email!);
        if (myUser == null) {
          await signOut();
          return null;
        }
        _myUser = myUser;
        myUser.printInfo();

        return null;
      }
    } on firebase.FirebaseException catch (error) {
      AuthError authError = AuthError(
        message:
            AuthError.getFirebaseAuthError(error.code) ?? 'firebase auth error',
        type: ErrorType.auth,
        code: error.code,
      );
      return authError;
    } catch (e) {
      print("Error on loginWithEmailAndPassword: $e");
    }
    return AuthError(
        message: 'Server Error', type: ErrorType.auth, code: 'server-error');
  }

  Future<AuthError?> loginWithGoogle() async {
    return await signinWithGoogle(isLogin: true);
  }

  Future<void> signOut() async {
    try {
      print("Sign out Method has been called");
      await _firebaseAuth.signOut();
      await GoogleSignIn().signOut();
    } catch (e) {
      return;
    }
  }
}
