import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ContactFormDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const ContactDialog(),
    );
  }
}

class ContactDialog extends StatefulWidget {
  const ContactDialog({Key? key}) : super(key: key);

  @override
  State<ContactDialog> createState() => _ContactDialogState();
}

class _ContactDialogState extends State<ContactDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_id': 'service_vps5ghc',
          'template_id': 'template_d66tlgs',
          'user_id': 'UC1AW60amuD5-brBl',
          'template_params': {
            'from_name': _nameController.text,
            'from_email': _emailController.text,
            'subject': _subjectController.text,
            'message': _messageController.text,
            'to_email': 'yasserelabasy1997@gmail.com',
          }
        }),
      );

      print("Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        _showSuccessMessage();
      } else {
        _showErrorMessage();
      }
    } catch (e) {
      print("Error: $e");
      _showErrorMessage();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Your message has been sent successfully! We will respond to you soon.ً'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.of(context).pop();
  }

  void _showErrorMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('There was a sending error, please try again.'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 600;
    final isVerySmallScreen = screenWidth < 400;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      insetPadding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 16 : 40,
        vertical: isSmallScreen ? 16 : 40,
      ),
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxWidth: isSmallScreen ? screenWidth : 500,
            maxHeight: screenHeight * 0.9,
          ),
          padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Contact me',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 20 : 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      iconSize: isSmallScreen ? 20 : 24,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Name Field
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Name *',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.person),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 12 : 16,
                      vertical: isSmallScreen ? 14 : 16,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: isSmallScreen ? 12 : 16),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Email *',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.email),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 12 : 16,
                      vertical: isSmallScreen ? 14 : 16,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email address.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: isSmallScreen ? 12 : 16),

                // Subject Field
                TextFormField(
                  controller: _subjectController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Subject *',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.subject),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 12 : 16,
                      vertical: isSmallScreen ? 14 : 16,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Your Subject';
                    }
                    return null;
                  },
                ),
                SizedBox(height: isSmallScreen ? 12 : 16),

                // Message Field
                TextFormField(
                  controller: _messageController,
                  style: const TextStyle(color: Colors.black),
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Message *',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.message),
                    alignLabelWithHint: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 12 : 16,
                      vertical: isSmallScreen ? 14 : 16,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please write the message';
                    }
                    return null;
                  },
                ),
                SizedBox(height: isSmallScreen ? 20 : 24),

                // Buttons
                if (isVerySmallScreen)
                  Column(
                    children: [
                      // Send Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _sendEmail,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: EdgeInsets.symmetric(
                              vertical: isSmallScreen ? 14 : 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isLoading
                              ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Sending.....',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )
                              : const Text(
                            'Send message',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Cancel Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            padding: EdgeInsets.symmetric(
                              vertical: isSmallScreen ? 14 : 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      // Send Button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _sendEmail,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: EdgeInsets.symmetric(
                              vertical: isSmallScreen ? 14 : 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isLoading
                              ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Sending.....',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )
                              : const Text(
                            'Send message',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(width: isSmallScreen ? 12 : 16),

                      // Cancel Button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            padding: EdgeInsets.symmetric(
                              vertical: isSmallScreen ? 14 : 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                SizedBox(height: isSmallScreen ? 8 : 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}