import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business/cubit/auth_cubit.dart';
import 'register_screen.dart';
import 'address_registration_screen.dart';

class RegistrationFlowManager extends StatelessWidget {
  const RegistrationFlowManager({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: const RegistrationFlowManagerBody(),
    );
  }
}

class RegistrationFlowManagerBody extends StatelessWidget {
  const RegistrationFlowManagerBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is RegistrationStepState) {
          switch (state.currentStep) {
            case 1:
              return const RegisterScreenBody();
            case 2:
              return const AddressRegistrationScreen();
            default:
              return const RegisterScreenBody();
          }
        }

        return const RegisterScreenBody();
      },
    );
  }
}
