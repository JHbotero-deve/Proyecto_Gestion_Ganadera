import 'package:flutter/material.dart';
import '../../../../core/theme/gavac_colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _fincaController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  static const String appName = 'GAVAC';
  static const String appSlogan = 'Únete a la revolución\nde la gestión ganadera.';

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _fincaController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cuenta creada exitosamente. Inicia sesión.'),
              backgroundColor: GavacColors.successText,
            ),
          );
          Navigator.pushReplacementNamed(context, '/login');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 768;

    return Scaffold(
      body: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // LADO IZQUIERDO - Formulario
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.white,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 48),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Crear Cuenta',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: GavacColors.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Completa tus datos para comenzar.',
                        style: TextStyle(fontSize: 16, color: Color(0xFF757575)),
                      ),
                      const SizedBox(height: 32),

                      _buildTextField('Nombre completo', 'Juan Pérez', _nombreController, Icons.person_outline),
                      const SizedBox(height: 20),
                      _buildTextField('Correo electrónico', 'juan@finca.com', _emailController, Icons.email_outlined, TextInputType.emailAddress),
                      const SizedBox(height: 20),
                      _buildTextField('Nombre de la finca', 'Finca La Esperanza', _fincaController, Icons.agriculture_outlined),
                      const SizedBox(height: 20),
                      _buildPasswordField('Contraseña', _passwordController, _obscurePassword, () => setState(() => _obscurePassword = !_obscurePassword)),
                      const SizedBox(height: 20),
                      _buildPasswordField('Confirmar contraseña', _confirmPasswordController, _obscureConfirmPassword, () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword)),
                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleRegister,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: GavacColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 8,
                            shadowColor: GavacColors.primary.withValues(alpha: 0.3),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: _isLoading
                              ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                              : const Text('Registrarme', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: TextButton(
                          onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                          child: const Text('¿Ya tienes cuenta? Inicia sesión', style: TextStyle(color: GavacColors.primary, fontWeight: FontWeight.w600, fontSize: 14)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // LADO DERECHO - Imagen de fondo
        Expanded(
          flex: 1,
          child: Container(
            color: const Color(0xFF6B8E85),
            child: Stack(
              children: [
                const Positioned.fill(
                  child: Opacity(
                    opacity: 0.3,
                    child: Image(
                      image: AssetImage('assets/imagenes/imagenlogin.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Positioned.fill(
                  child: ColoredBox(color: Color(0x33000000)),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(48.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          appName,
                          style: TextStyle(fontSize: 72, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -2, shadows: [Shadow(color: Color(0x80000000), offset: Offset(0, 4), blurRadius: 8)]),
                        ),
                        SizedBox(height: 16),
                        Text(
                          appSlogan,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.white, height: 1.4, shadows: [Shadow(color: Color(0x80000000), offset: Offset(0, 2), blurRadius: 4)]),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              const Text('Crear Cuenta', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: GavacColors.primary)),
              const SizedBox(height: 8),
              const Text('Completa tus datos para comenzar.', style: TextStyle(fontSize: 14, color: Color(0xFF757575))),
              const SizedBox(height: 32),
              _buildTextField('Nombre completo', 'Juan Pérez', _nombreController, Icons.person_outline),
              const SizedBox(height: 16),
              _buildTextField('Correo electrónico', 'juan@finca.com', _emailController, Icons.email_outlined, TextInputType.emailAddress),
              const SizedBox(height: 16),
              _buildTextField('Nombre de la finca', 'Finca La Esperanza', _fincaController, Icons.agriculture_outlined),
              const SizedBox(height: 16),
              _buildPasswordField('Contraseña', _passwordController, _obscurePassword, () => setState(() => _obscurePassword = !_obscurePassword)),
              const SizedBox(height: 16),
              _buildPasswordField('Confirmar contraseña', _confirmPasswordController, _obscureConfirmPassword, () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword)),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleRegister,
                  style: ElevatedButton.styleFrom(backgroundColor: GavacColors.primary, foregroundColor: Colors.white, elevation: 4, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: _isLoading ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation<Color>(Colors.white))) : const Text('Registrarme', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                  child: const Text('¿Ya tienes cuenta? Inicia sesión', style: TextStyle(color: GavacColors.primary, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller, IconData icon, [TextInputType? type]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: GavacColors.textPrimary)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: type,
          decoration: InputDecoration(hintText: hint, hintStyle: const TextStyle(color: Color(0xFF9E9E9E)), prefixIcon: Icon(icon, color: const Color(0xFF9E9E9E)), filled: true, fillColor: const Color(0xFFF8FAFC), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFD1D5DB))), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFD1D5DB))), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: GavacColors.primary, width: 2)), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16)),
          validator: (v) => (v == null || v.isEmpty) ? 'Campo obligatorio' : null,
        ),
      ],
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller, bool obscure, VoidCallback toggle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: GavacColors.textPrimary)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(hintText: '••••••••', hintStyle: const TextStyle(color: Color(0xFF9E9E9E)), prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF9E9E9E)), suffixIcon: IconButton(icon: Icon(obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: const Color(0xFF9E9E9E)), onPressed: toggle), filled: true, fillColor: const Color(0xFFF8FAFC), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFD1D5DB))), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFD1D5DB))), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: GavacColors.primary, width: 2)), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16)),
          validator: (v) => (v == null || v.isEmpty) ? 'Campo obligatorio' : (v.length < 6 ? 'Mínimo 6 caracteres' : null),
        ),
      ],
    );
  }
}