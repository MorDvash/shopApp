import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/product.dart';
import 'package:shop_app/provider/productProvider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  var _imageUrlController = TextEditingController();
  final _priceFocusNode = FocusNode();
  var _isInit = true;
  var _isLoading = false;
  var _valueInit = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };
  // final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: '', title: '', description: '', imageUrl: '', price: 0);

  // void _updateUrl() {
  //   if (!_imageUrlFocusNode.hasFocus) {
  //     setState(() {});
  //   }
  // }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    _form.currentState!.save();
    if (_editedProduct.id.isNotEmpty) {
      await Provider.of<ProductProvider>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<ProductProvider>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Okey'),
              )
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments;
      if (productId != null) {
        _editedProduct =
            Provider.of<ProductProvider>(context).findById(productId as String);
        _valueInit = {
          'title': _editedProduct.title,
          'price': _editedProduct.price.toString(),
          'description': _editedProduct.description,
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit product'),
        actions: [
          IconButton(onPressed: () => _saveForm(), icon: Icon(Icons.save))
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _valueInit['title'],
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
                      initialValue: _valueInit['price'],
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
                          return 'Please enter number greater then zero.';
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
                      initialValue: _valueInit['description'],
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
                                  child:
                                      Image.network(_imageUrlController.text),
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
                              // if (!value.startsWith('http') &&
                              //     !value.startsWith('https')) {
                              //   return 'Please enter valid url';
                              // }
                              // if (value.endsWith('.png')) {
                              //   return 'please enter valid image';
                              // }
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
