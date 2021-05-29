import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_app/provider/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  @override
  Widget build(BuildContext context) {
    final _imageUrlController = TextEditingController();
    final _priceFocusNode = FocusNode();
    // final _imageUrlFocusNode = FocusNode();
    final _form = GlobalKey<FormState>();
    var _editedProduct =
        Product(id: '', title: '', description: '', imageUrl: '', price: 0);

    // void _updateUrl() {
    //   if (!_imageUrlFocusNode.hasFocus) {
    //     setState(() {});
    //   }
    // }

    void _saveForm() {
      final isValid = _form.currentState!.validate();
      if (!isValid) {
        return;
      }
      _form.currentState!.save();
      print(_editedProduct.title);
      print(_editedProduct.price);
      print(_editedProduct.description);
      print(_editedProduct.imageUrl);
    }

    // @override
    // void initState() {
    //   _imageUrlFocusNode.addListener(() {
    //     // ignore: unnecessary_statements
    //     _updateUrl;
    //   });
    //   super.initState();
    // }

    @override
    void dispose() {
      //כדי לא ליצור איחסון מיותר בזיכרון
      // _imageUrlFocusNode.removeListener(() {
      //   _updateUrl();
      // });
      _imageUrlController.dispose();
      _priceFocusNode.dispose();
      // _imageUrlFocusNode.dispose();
      super.dispose();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit product'),
        actions: [
          IconButton(onPressed: () => _saveForm(), icon: Icon(Icons.save))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  Focus.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide some data';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      id: _editedProduct.id,
                      title: value as String,
                      description: _editedProduct.description,
                      imageUrl: _editedProduct.imageUrl,
                      price: _editedProduct.price);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter price.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number.';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Plase enter number greater then zero.';
                  }
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      id: _editedProduct.id,
                      title: _editedProduct.title,
                      description: _editedProduct.description,
                      imageUrl: _editedProduct.imageUrl,
                      price: double.parse(value as String));
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  if (value.length < 10) {
                    return 'Description length need to be at least 10 characters';
                  }
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      id: _editedProduct.id,
                      title: _editedProduct.title,
                      description: value as String,
                      imageUrl: _editedProduct.imageUrl,
                      price: _editedProduct.price);
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? Text('Enter Image')
                        : FittedBox(
                            child: Image.network(_imageUrlController.text),
                            fit: BoxFit.cover,
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter image';
                        }
                        if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return 'Please enter valid url';
                        }
                        if (value.endsWith('.png')) {
                          return 'please enter valid image';
                        }
                      },
                      // onEditingComplete: () {
                      //   setState(() {});
                      // },
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            imageUrl: value as String,
                            price: _editedProduct.price);
                      },
                      // focusNode: _imageUrlFocusNode,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
