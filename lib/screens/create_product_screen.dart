import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class CreateProductScreen extends StatefulWidget {
  static const routeName = '/create-product';

  const CreateProductScreen({Key? key}) : super(key: key);

  @override
  _CreateProductScreenState createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  String _screenTitle = "Create Product";
  String _snackBarMessage = "Product Created";
  bool _productCreating = true;
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _productForm = GlobalKey<FormState>();
  var _product = Product.blueprint(id: DateTime.now().toString());
  bool buildingFirstTime = true;

  void _focusInput(BuildContext context, FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
  }

  void _freeMemory() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.removeListener(_updateImageUrl);
    _imageUrlController.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (!_validateImageUrl(_imageUrlController.text)) {
        return;
      }
      setState(() {});
    }
  }

  void _submit() {
    if (!_productForm.currentState!.validate()) {
      return;
    }
    _productForm.currentState!.save();
    final productProvider = Provider.of<Products>(context, listen: false);

    if (_productCreating) {
      productProvider.addProduct(_product);
    } else {
      productProvider.updateProduct(_product);
    }

    ScaffoldMessengerState scaffoldMessengerState =
        ScaffoldMessenger.of(context);
    scaffoldMessengerState.hideCurrentSnackBar();
    scaffoldMessengerState.showSnackBar(
      SnackBar(
        content: Text(_snackBarMessage),
      ),
    );

    Navigator.of(context).pop();
  }

  bool _validateImageUrl(String imageUrl) {
    return (imageUrl.isNotEmpty &&
        (imageUrl.startsWith('https') || imageUrl.startsWith('http')) &&
        (imageUrl.endsWith('.png') ||
            imageUrl.endsWith('.jpg') ||
            imageUrl.endsWith('.jpeg')));
  }

  @override
  void initState() {
    _imageUrlController.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _freeMemory();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (buildingFirstTime) {
      final productId = ModalRoute.of(context)!.settings.arguments;

      if (productId != null) {
        _product =
            Provider.of<Products>(context).findById(productId.toString());
        _imageUrlController.text = _product.imageUrl;

        _productCreating = false;
        _screenTitle = "Edit Product - ${_product.title}";
        _snackBarMessage = "Product Updated";
      }
    }

    buildingFirstTime = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_screenTitle),
        actions: [
          IconButton(
            onPressed: _submit,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _productForm,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _product.title,
                decoration: const InputDecoration(
                  label: Text('Title'),
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => _focusInput(context, _priceFocusNode),
                onSaved: (value) {
                  _product = Product.blueprint(
                    id: _product.id,
                    isFavourite: _product.isFavourite,
                    title: value.toString(),
                    description: _product.description,
                    price: _product.price,
                    imageUrl: _product.imageUrl,
                  );
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Title must not be empty!";
                  }
                },
              ),
              TextFormField(
                initialValue: _product.price.toString(),
                decoration: const InputDecoration(
                  label: Text("Price"),
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) =>
                    _focusInput(context, _descriptionFocusNode),
                onSaved: (value) {
                  _product = Product.blueprint(
                    id: _product.id,
                    isFavourite: _product.isFavourite,
                    title: _product.title,
                    description: _product.description,
                    price: 1,
                    imageUrl: _product.imageUrl,
                  );
                },
                validator: (value) {
                  if (double.tryParse(value!) == null ||
                      double.tryParse(value)! <= 0) {
                    return "Please enter a valid price";
                  }
                },
              ),
              TextFormField(
                initialValue: _product.description,
                decoration: const InputDecoration(
                  label: Text("Description"),
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                focusNode: _descriptionFocusNode,
                onSaved: (value) {
                  _product = Product.blueprint(
                    id: _product.id,
                    isFavourite: _product.isFavourite,
                    title: _product.title,
                    description: value.toString(),
                    price: _product.price,
                    imageUrl: _product.imageUrl,
                  );
                },
                validator: (value) {
                  if (value!.isEmpty || value.length < 10) {
                    return "Please enter a description which has minimum 10 characters";
                  }
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(
                      top: 25,
                      right: 25,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? const Center(child: Text('Image'))
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                        decoration: const InputDecoration(
                          label: Text("Image URL"),
                        ),
                        keyboardType: TextInputType.url,
                        focusNode: _imageUrlFocusNode,
                        controller: _imageUrlController,
                        onSaved: (value) {
                          _product = Product.blueprint(
                            id: _product.id,
                            isFavourite: _product.isFavourite,
                            title: _product.title,
                            description: _product.description,
                            price: _product.price,
                            imageUrl: value.toString(),
                          );
                        },
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _submit(),
                        validator: (value) {
                          if (!_validateImageUrl(value!)) {
                            return "Please enter a valid image url";
                          }
                        }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
