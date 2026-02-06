import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sustainai_flutter/core/services/supabase_service.dart';
import 'package:sustainai_flutter/features/auth/models/profile_model.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  ProfileModel? _profile;
  Session? _session;
  bool _loading = true;
  String? _error;
  
  User? get user => _user;
  ProfileModel? get profile => _profile;
  Session? get session => _session;
  bool get loading => _loading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;
  
  AuthProvider() {
    _initialize();
  }
  
  Future<void> _initialize() async {
    try {
      // Get initial session
      final session = SupabaseService.currentSession;
      _session = session;
      _user = session?.user;
      
      if (_user != null) {
        await _fetchProfile(_user!.id);
      }
      
      // Listen to auth state changes
      SupabaseService.authStateChanges.listen((authState) {
        _session = authState.session;
        _user = authState.session?.user;
        
        if (_user != null) {
          _fetchProfile(_user!.id);
        } else {
          _profile = null;
        }
        
        notifyListeners();
      });
    } catch (e) {
      _error = e.toString();
      debugPrint('Auth initialization error: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
  
  Future<void> _fetchProfile(String userId) async {
    try {
      final response = await SupabaseService.client
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      
      _profile = ProfileModel.fromJson(response);
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching profile: $e');
    }
  }
  
  Future<Map<String, dynamic>> signIn(String email, String password) async {
    try {
      _error = null;
      _loading = true;
      notifyListeners();
      
      final response = await SupabaseService.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      _user = response.user;
      _session = response.session;
      
      if (_user != null) {
        await _fetchProfile(_user!.id);
      }
      
      _loading = false;
      notifyListeners();
      return {'success': true};
    } catch (e) {
      _error = e.toString();
      _loading = false;
      notifyListeners();
      return {'success': false, 'error': e.toString()};
    }
  }
  
  Future<Map<String, dynamic>> signUp(String email, String password, String fullName) async {
    try {
      _error = null;
      _loading = true;
      notifyListeners();
      
      final response = await SupabaseService.client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );
      
      _user = response.user;
      _session = response.session;
      
      _loading = false;
      notifyListeners();
      return {'success': true};
    } catch (e) {
      _error = e.toString();
      _loading = false;
      notifyListeners();
      return {'success': false, 'error': e.toString()};
    }
  }
  
  Future<void> signOut() async {
    try {
      await SupabaseService.client.auth.signOut();
      _user = null;
      _profile = null;
      _session = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      debugPrint('Sign out error: $e');
    }
  }
  
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> updates) async {
    if (_user == null) {
      return {'success': false, 'error': 'No user logged in'};
    }
    
    try {
      updates['updated_at'] = DateTime.now().toIso8601String();
      
      await SupabaseService.client
          .from('profiles')
          .update(updates)
          .eq('id', _user!.id);
      
      // Update local profile
      if (_profile != null) {
        _profile = ProfileModel.fromJson({
          ..._profile!.toJson(),
          ...updates,
        });
        notifyListeners();
      }
      
      return {'success': true};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }
}
