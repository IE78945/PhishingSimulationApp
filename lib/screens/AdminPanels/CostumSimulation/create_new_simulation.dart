
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:phishing_simulation_app/constant.dart';
import 'package:phishing_simulation_app/models/simulation_model.dart';
import 'package:phishing_simulation_app/repository/simulation_repository.dart';
import 'package:phishing_simulation_app/screens/Components/CostumButtonForInterfaces.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';
import 'package:phishing_simulation_app/screens/Components/CustomButtonForm.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

class CreateNewSimulation extends StatefulWidget {
  const CreateNewSimulation({Key? key}) : super(key: key);

  @override
  State<CreateNewSimulation> createState() => _CreateNewSimulationState();
}

class _CreateNewSimulationState extends State<CreateNewSimulation> {
  final GlobalKey<FormState> _formKey_createsimulation = GlobalKey<FormState>();
  late TextEditingController _simulationNameController =
      TextEditingController();
  final _SimulationRepo = Get.put(SimulationRepository());
  bool isLoadingForm = false;

  // colonnig web site variables
  TextEditingController _WebPageController = TextEditingController();
  bool isLoading = false, isClonningEnd = false, isClonningResult = false;
  String clonedHtml = ''; // Store the fetched and saved HTML content
  late String WebSiteURL;

  //Generating email variables
  final QuillEditorController emailEditorController = QuillEditorController();
  late TextEditingController _senderAddressController = TextEditingController();
  late TextEditingController _senderNameController = TextEditingController();
  late TextEditingController _objectController = TextEditingController();

  Future<void> CloneWebPage(BuildContext context) async {
    WebSiteURL = _WebPageController.text;
    final url = Uri.parse('http://localhost:3000/proxy?url=$WebSiteURL');
    // show loading sign
    setState(() {
      isLoading = true;
    });
    // get website code from proxy
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // web site clonned by proxy server successfully
      clonedHtml = response.body;
      // dispaly  a success mark instead of the button
      setState(() {
        isClonningEnd = true;
        isClonningResult = true;
      });
    } else {
      // something went wrong with the proxy server : connexion , ....

      print("Error: ${response.statusCode} - ${response.body}");
      // display a failure mark
      setState(() {
        isClonningEnd = true;
        isClonningResult = false;
      });
    }
  }

  Future<void> saveSimulation(BuildContext context) async {
    //Get the html code as string from editor
    String? htmlText = await emailEditorController.getText();

    if (_formKey_createsimulation.currentState!.validate() && (clonedHtml != "" ) && ( htmlText != "")) {
      setState(() {
        isLoadingForm = true;
      });
      // Save clonned web page code to firebase storage
      String DownloadFileURL_webSite =
          await _SimulationRepo.UploadWebSiteHtmlCode(WebSiteURL, clonedHtml);
      // Save email template html code to firebase Storage

      // Save email template html code to firebase Storage
      String DownloadFileURL_emailTemplate =
          await _SimulationRepo.UploadEmailTemplate(htmlText);

      if (DownloadFileURL_webSite != "" &&
          DownloadFileURL_emailTemplate != "") {
        // html file of web site and email template has been saved succesfuly
        // Save Simulation in firestore
        SimulationModel model = SimulationModel(
          SimulationName: _simulationNameController.text,
          EmailTemplateFileDownloadUrl: DownloadFileURL_emailTemplate,
          WebSiteFileDownloadUrl: DownloadFileURL_webSite,
          WebSiteURL: WebSiteURL,
          Object: _objectController.text,
          SenderEmail: _senderAddressController.text,
          SenderName: _senderNameController.text,
        );
        await _SimulationRepo.AddSimulation(model);
        setState(() {
          isLoadingForm = false;
        });
      } else {
        //  there has been an error and the app couldn't store the files in storage
        setState(() {
          isLoadingForm = false;
        });
        Get.snackbar(
          "Error",
          "Something went wrong.Please check your network and retry later.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.white.withOpacity(0.7),
          colorText: Colors.red,
        );
      }
    } else {
      Get.snackbar(
        "Error",
        "Form not valid. Please enter email and make sure to clone the webSite.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white.withOpacity(0.7),
        colorText: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
        height: MediaQuery.of(context).size.height ,
    width:MediaQuery.of(context).size.width  ,
      child : SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.02),
        child:  Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        Text(
        "Create a new Simulation",
        style: TextStyle(
          fontSize: 34,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w600,
        ),
      ),
        Form(
          key: _formKey_createsimulation,
          child:
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //mini title : SimulationName
                    Container(
                      margin: EdgeInsets.only(top: 12.0),
                      decoration: BoxDecoration(
                        border: Border(left: BorderSide(width: 2, color: Colors.black)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Simulation Name",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 16),
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: MediaQuery.of(context).size.height * 0.02),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Simulation Name',
                                border: InputBorder.none,
                              ),
                              controller: _simulationNameController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "This field should not be empty";
                                }
                                return null;
                              },
                            ),
                          ),
                        )),

                    //mini title
                    Container(

                      decoration: BoxDecoration(
                        border: Border(left: BorderSide(width: 2, color: Colors.black)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Web Site",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    //Web page to clone URL
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 16),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.height * 0.02),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: TextField(
                                  controller: _WebPageController,
                                  decoration: InputDecoration(
                                    hintText: 'https://www.exemple.com',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 5),

                          //Button
                          isClonningEnd
                              ? Expanded(
                                  flex: 1,
                                  child: isClonningResult
                                      ? Icon(
                                          Icons.check_circle_outline,
                                          color: Colors.green,
                                        )
                                      : Icon(
                                          Icons.cancel_outlined,
                                          color: Colors.red,
                                        ),
                                )
                              : Expanded(
                                  flex: 1,
                                  child: isLoading
                                      ? CircularProgressIndicator(
                                          color: Colors.blue,
                                        )
                                      : CustomButtonForInterfaces(
                                          context,
                                          BtnAction: () {
                                            CloneWebPage(context);
                                          },
                                          textBtn: 'Clone',
                                          icon: Icon(Icons.copy_all_outlined),
                                          paddingsize: 12.0,
                                        ),
                                )
                        ],
                      ),
                    ),

                    // display web page if cloning is successfull
                    if (isClonningResult)
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.height * 0.02),
                        child: Text(
                          "Content may not render as expected, it's possible that the package used to dispaly the page  is missing some necessary styling features.\n if content (text) is correct , i'll be displayed properly when employees visite the web site. ",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    if (isClonningResult)
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.height * 0.02),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Html(
                            data: clonedHtml,
                          ),
                        ),
                      ),

                    //mini title : emails templates
                    Container(
                      margin: EdgeInsets.only(bottom: 12.0, top: 12.0),
                      decoration: BoxDecoration(
                        border: Border(left: BorderSide(width: 2, color: Colors.black)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "email template",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),

                    //sender name
                    const Text(
                      "Sender Name",
                      style: TextFieldTitle,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 16),
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.height * 0.02),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextFormField(
                            controller: _senderNameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "This field should not be empty";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'name',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),

                    //Sender address
                    const Text(
                      "Sender email address",
                      style: TextFieldTitle,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 16),
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.height * 0.02),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'exemple@gmail.com',
                              border: InputBorder.none,
                            ),
                            controller: _senderAddressController,
                            validator: (value) {
                              if (value!.isEmpty || !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
                                return "Please enter a valid email address";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),

                    //Object
                    const Text(
                      "Object",
                      style: TextFieldTitle,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 16),
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.height * 0.02),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextFormField(
                            controller: _objectController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "This field should not be empty";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'object',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),

                    ToolBar(
                      toolBarColor: Colors.white.withOpacity(0.95),
                      activeIconColor: Colors.blue,
                      padding: const EdgeInsets.all(8),
                      iconSize: 20,
                      controller: emailEditorController,
                      /*
                        customButtons: [
                              InkWell(onTap: () {}, child: const Icon(Icons.favorite)),
                              InkWell(onTap: () {}, child: const Icon(Icons.add_circle)),

                        ],

                         */
                    ),
                    Text(
                        "You can use these placeholders as well [EMPLOYEE_NAME], [DEPARTMENT_NAME]. They will be customized for each employee later.",
                        style: TextStyle(
                          color: Colors.grey,
                        )),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: QuillHtmlEditor(
                        hintText: 'Please style your email',
                        controller: emailEditorController,
                        isEnabled: true,
                        minHeight: 300,
                        hintTextAlign: TextAlign.start,
                        padding: const EdgeInsets.only(left: 10, top: 5),
                        hintTextPadding: EdgeInsets.zero,
                        backgroundColor: Colors.white.withOpacity(0.95),
                        onFocusChanged: (hasFocus) => debugPrint('has focus $hasFocus'),
                        onTextChanged: (text) => debugPrint('widget text change $text'),
                        onEditorCreated: () => debugPrint('Editor has been loaded'),
                        onEditingComplete: (s) => debugPrint('Editing completed $s'),
                        onEditorResized: (height) =>
                            debugPrint('Editor resized $height'),
                        onSelectionChanged: (sel) =>
                            debugPrint('${sel.index},${sel.length}'),
                        loadingBuilder: (context) {
                          return const Center(
                              child: CircularProgressIndicator(
                            strokeWidth: 0.4,
                          ));
                        },
                      ),
                    ),

                    //Button
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 24),
                      child: CustomButtonForm(
                        context,
                        BtnAction: () {
                          saveSimulation(context);
                        },
                        textBtn: 'Save',
                        icon: Icons.save,
                        widthBtn: double.maxFinite,
                        topLeftRadius: 25,
                        isLoading: isLoadingForm,
                      ),
                    ),
          ]),
        ),
      ])
      ),
    )
    ));
  }
}
