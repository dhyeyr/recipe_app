// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
//
// import '../model/user_model.dart';
//
// class ImageController extends GetxController{
//   RxString filepath="".obs;
//
//
//   // void pickImage(bool isCamara) async {
//   //   XFile? file = await ImagePicker()
//   //       .pickImage(source: isCamara ? ImageSource.camera : ImageSource.gallery);
//   //   filepath.value = file!.path;
//   //   AddUser(image: filepath.value);
//   // }
//
// }







// ListView.builder(
// shrinkWrap: true,
// itemCount: detail.length,
// itemBuilder: (context, index) {
// var productDetail = detail[index];
// var imagePath = productDetail["image"]; // Assuming "image" is the field containing the file path
//
// // Create a File object from the image path
// File file = File(imagePath);
//
// // Check if the file exists
// if (file.existsSync()) {
// // File exists, you can proceed with operations like loading or decoding
// print('File exists at specified path: $imagePath');
// // Example: Load image using Image.file
// return Card(
// color: Colors.pink[50],
// child: ListTile(
// leading: CircleAvatar(
// radius: 30,
// backgroundImage: FileImage(file),
// ),
// trailing: IconButton(
// onPressed: () {
// // Handle button press
// },
// icon: Icon(Icons.add_shopping_cart_outlined),
// ),
// title: Text(productDetail["name"]),
// subtitle: Text(productDetail["description"]),
// ),
// );
// } else {
// // Handle case where file does not exist
// print('File does not exist at specified path: $imagePath');
// return SizedBox(); // Return an empty SizedBox or placeholder widget
// }
// },
// );