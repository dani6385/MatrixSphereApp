
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current profile data (dummy data for now)
    _nameController.text = 'John Doe';
    _emailController.text = 'john.doe@example.com';
    _phoneController.text = '+62 81234 5678 900';
    _addressController.text = '123 Main St, Anytown USA';
    _companyController.text = 'ABC Corp';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Here you would typically send the updated data to a backend service
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved successfully!')),
      );
      Navigator.of(context).pop(); // Go back to the profile screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: kBrandTertiary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kBrandPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(
                    'https://via.placeholder.com/150'), // Replace with actual profile image
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _companyController,
                decoration: const InputDecoration(
                  labelText: 'Company',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your company name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: 'Save Changes',
                onTap: _saveProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
