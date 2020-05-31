import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static final routeName = "/product_edit_screen";

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();

  final _imageURLController = TextEditingController();

  final _form = GlobalKey<FormState>();

  bool init = true;

  Product editedProduct =
      Product(id: null, title: '', description: '', price: 0, imageUrl: '');

  var initialValues = {"title": '', "description": '', "price": ''};

  void _saveForm() {
    var validate = _form.currentState.validate();
    if (!validate) {
      return;
    }
    _form.currentState.save();
    var products = Provider.of<Products>(context, listen: false);
    if (editedProduct.id == null) {
      products.addProduct(editedProduct);
    } else {
      products.updateProduct(editedProduct);
    }
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImage);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (init == true) {
      final productId = ModalRoute.of(context).settings.arguments;
      if (productId != null) {
        editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);

        initialValues['title'] = editedProduct.title;
        initialValues['description'] = editedProduct.description;
        initialValues['price'] = editedProduct.price.toString();

        _imageURLController.text = editedProduct.imageUrl;
      }
    }
    init = false;
    super.didChangeDependencies();
  }

  void _updateImage() {
    if (_imageURLController.text.isEmpty) {
      return;
    }
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImage);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageURLController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Product"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: initialValues["title"],
                decoration: InputDecoration(labelText: "Title"),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (val) {
                  if (val.isEmpty) {
                    return "Please Enter a Title";
                  }
                  return null;
                },
                onSaved: (val) {
                  editedProduct = Product(
                      id: editedProduct.id,
                      title: val,
                      description: editedProduct.description,
                      price: editedProduct.price,
                      imageUrl: editedProduct.imageUrl,
                      isFavorite: editedProduct.isFavorite,
                      );
                },
              ),
              TextFormField(
                initialValue: initialValues["price"],
                decoration: InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                validator: (val) {
                  if (val.isEmpty) {
                    return "Please Enter a valid Price";
                  }
                  if (double.parse(val) <= 0) {
                    return "Please Enter a valid Price";
                  }
                  return null;
                },
                onSaved: (val) {
                  editedProduct = Product(
                      id: editedProduct.id,
                      title: editedProduct.title,
                      description: editedProduct.description,
                      price: double.parse(val),
                      imageUrl: editedProduct.imageUrl,
                      isFavorite: editedProduct.isFavorite,
                      );
                },
              ),
              TextFormField(
                initialValue: initialValues["description"],
                decoration: InputDecoration(labelText: "Description"),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                validator: (val) {
                  if (val.isEmpty) {
                    return "Please Enter Description";
                  }
                  return null;
                },
                onSaved: (val) {
                  editedProduct = Product(
                    id: editedProduct.id,
                    title: editedProduct.title,
                    description: val,
                    price: editedProduct.price,
                    imageUrl: editedProduct.imageUrl,
                    isFavorite: editedProduct.isFavorite,
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(left: 8, right: 8, top: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1, color: Theme.of(context).primaryColor),
                    ),
                    child: _imageURLController.text.isEmpty
                        ? Text("Enter an URL")
                        : FittedBox(
                            child: Image.network(_imageURLController.text),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: "Image URL"),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageURLController,
                      focusNode: _imageUrlFocusNode,
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Please Enter an URL";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        editedProduct = Product(
                          id: editedProduct.id,
                          title: editedProduct.title,
                          description: editedProduct.description,
                          price: editedProduct.price,
                          imageUrl: val,
                          isFavorite: editedProduct.isFavorite,
                        );
                      },
                      onFieldSubmitted: (_) => _saveForm(),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
