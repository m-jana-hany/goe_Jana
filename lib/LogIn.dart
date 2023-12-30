import 'package:flutter/material.dart';
import 'SignUp.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogIn extends StatelessWidget {

   LogIn({super.key});

  final formKey = GlobalKey<FormState>();

   final TextEditingController controllerUsername = TextEditingController();

   final TextEditingController controllerID = TextEditingController();


  @override


  Widget build(BuildContext context) {


    return Scaffold(

      backgroundColor: const Color(0xffeadacb),

      appBar: AppBar(
        shadowColor: const Color(0xff5C9A2E),
          backgroundColor: const Color(0xff5C9A2E),

   leading: Builder(
     builder:(context)=> IconButton(onPressed: (){
       Navigator.push(context, MaterialPageRoute(builder: (context)=> const SignUp()));
     }, icon: const Icon(Icons.arrow_back, ) ),
   ),

          title: const Text('Log In', style: TextStyle( color: Color(0xFFFCE4D4),
              fontSize: 40, fontWeight: FontWeight.bold), ),


      ),

      body:

      Center(
        child: Padding(
          padding: const EdgeInsets.all(11.0),
          child: SingleChildScrollView(
            child: Container(

              child:

                Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      TextFormField

                        (
                    controller: controllerUsername,
                        cursorColor: const Color(0xFF262524),
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          filled: true,
                          fillColor: Color(0xffdddea6),
                  suffixIcon: Icon(Icons.email_outlined),

                        ),
                  onSaved: (value) {
                    controllerUsername.text = value!;
                  },
                    validator: (value) {
                      if (value == null || value == '') {
                        return 'Enter valid Email.';
                      }
                      return null;
                    },
                ),




                      const SizedBox(height: 50,),

                      TextFormField(
                   keyboardType: TextInputType.number,
                        cursorColor: const Color(0xFF262524),
                        decoration:
                        const InputDecoration(
                          labelText: 'National ID as password',
                          filled: true,
                          fillColor: Color(0xffdddea6),
                          suffixIcon: Icon(Icons.perm_identity),


                        ),
                        onSaved: (value) {
                          controllerID.text = value!;
                        },

                        validator: (value) {
                          if ( value == null || value.length != 14
                        ) {
                            return 'Enter valid National ID that should be exactly 14 numbers.';
                          }
                          return null;
                        },
                      ),




            const SizedBox(height: 60,),

                      MaterialButton(

                          shape:
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: const Color(0xff5C9A2E),



                          child:



                          Builder(
                            builder: (context)=>
                                const Text('  Log In ', style: TextStyle( color: Color(
                                    0xFFFCE4D4),
                                    fontSize: 35, fontWeight: FontWeight.bold), ),

                          ),
                   
                    onPressed:()    {
                      if (formKey.currentState!.validate()) {
                           FirebaseAuth.instance.signInAnonymously();
                           signInWithEmailAndPassword(controllerUsername.text, controllerID.text);
                          formKey.currentState!.validate();
                            controllerUsername.clear();
                            controllerID.clear();
                            Navigator.pop(context); 
                      } 
                         
                        }

            ),
    
               const SizedBox(height: 16.0),

            GestureDetector(
                    onTap: () {
                    // Navigate to the sign-in page
                  Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LogIn()),
             ); 
                    },
                    child: const Text('Already have an account? Sign In' ),
                  ),

        ]),
                ),

              ),
              
          ),

            ),
      ),





    );
  }
}

///////////////////////////////////////////
// code for logging in:

Future<void> signInWithEmailAndPassword(String email, String password) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    print('User signed in successfully');
  } catch (e) {
    print('Error signing in: $e');
    // You can handle different sign-in errors here (e.g., wrong password, user not found)
  }
}