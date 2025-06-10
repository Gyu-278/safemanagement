import SwiftUI

struct ContentView: View {
    
    @State private var username = ""
    @State private var password = ""
    @State private var wrongUsername = 0
    @State private var wrongPassword = 0
    //initialize the showing login screen as false
    //because we need to build the login screen UI
    @State private var showingLoginScreen = false
    
    //design the UI
    
    var body: some View {
        
        //we want to hide navigation bar and leave it blank
        
        NavigationView{
            //give UI some nice background
            ZStack{
                Color.blue
                    .ignoresSafeArea()
                //outter layer - opacity circle
                Circle()
                    .scale(2.0)
                    .foregroundColor(.white.opacity(0.3))
                //inner layer - bright white circle
                Circle()
                    .scale(1.35)
                    .foregroundColor(.white)
                
                VStack{
                    Text("Safety \n Management")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                        .multilineTextAlignment(.center)
                    //username filling-in blank
                    //binding type of username attribute
                    TextField("Enter Your Username", text: $username)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.blue.opacity(0.05))
                        //corner radius to make text field shape looks nice
                        .cornerRadius(10)
                        //border if the user pick something wrong
                        //i.e. a wrong username that doesn't exist
                        //wrong password etc.
                        //must be passing the error with CGFloat
                        .border(.red, width: CGFloat(wrongUsername))
                    //password filling-in blank
                    //similarly to username
                    //use SecureField to encrpt passcode into dark bullet points when entering
                    SecureField("Enter Your Password", text: $password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.blue.opacity(0.05))
                        //corner radius to make text field shape looks nice
                        .cornerRadius(10)
                        //border if the user pick something wrong
                        //i.e. a wrong username that doesn't exist
                        //wrong password etc.
                        //must be passing the error with CGFloat
                        .border(.red, width: CGFloat(wrongPassword))
                    //give user a button for login
                    //we want to give it a float-shaped effect
                    //since the default button doesn't fit the UI
                    Button("Login"){
                        //Authenticate user
                        authenticateUser(username: username, password: password)
    
                    }
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
                    //provide a navigation link can send user to user page
                    //if they successfully login
                    //so we can program the login page USING THIS LINK
                    NavigationLink(
                        destination: MainView(username: username),
                        isActive: $showingLoginScreen
                        ) {
                            EmptyView()
                    }
                }
            }
            .navigationBarHidden(true)

        }
    
    }
    //create the Authenticate user function
    //use lowercased() to ignore cases(prevent case sensitive)
    func authenticateUser(username: String, password: String){
        //username check
        if username.lowercased() == "group4" {
            //correct+authenticated username, set wrongUsername to 0
            wrongUsername = 0
            //password check
            if password.lowercased() == "group4"{
                wrongPassword = 0
                //both username and password are correct and authenticated
                //show user the login screen
                showingLoginScreen = true
            }
            else{
                //wrong password
                //set wrongPassword = 2 to show red-warning in text field
                wrongPassword = 2
            }
        }
        else{
            //wrong username
            //set wrongUsername = 2 to show red-warning in text field
            wrongUsername = 2
        }

    }
    
    //to make this authentication function work
    //we need to insert/call this inside the Button
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
