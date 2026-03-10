import 'package:flutter/material.dart';
import 'login_page.dart';
import '../services/cart_service.dart';
import 'basket_page.dart';
import '../services/session_service.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../services/auth_service.dart';
import '../widgets/app_bottom_nav.dart';
import 'categories_page.dart';
import 'wishlist_page.dart';
import '../services/wishlist_service.dart';
import 'account_page.dart';
class HomePage extends StatefulWidget {
  static const String routeName = '/home';
  const HomePage({super.key});
  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}
class _HomePageState extends State<HomePage>{
  final TextEditingController _searchController=TextEditingController();
  List<Product> _allProducts=[];
  bool _loading=true;
  String? _error;
  int _bottomNavIndex=0;
  int _selectedTopTabIndex= 0;
  @override
  void initState(){
    super.initState();
    _loadProducts();
    _searchController.addListener((){
      setState(() {});
    });
  }
  @override
  void dispose(){
    _searchController.dispose();
    super.dispose();
  }
  Future<void> _loadProducts() async{
    setState(() {
      _loading=true;
      _error=null;
    });
    try{
      final List<Product> products=await ProductService.getAllProducts();
      setState((){
        _allProducts=products;
      });
    }catch (e){
      setState(() {
        _error=e.toString();
      });
    }
    setState(() {
      _loading=false;
    });
  }
  List<Product> get _filteredProducts{
    List<Product> result=List<Product>.from(_allProducts);
    final String query =_searchController.text.trim().toLowerCase();
    if (query.isNotEmpty){
      result=result.where((product){
        final String name=product.name.toLowerCase();
        final String description =(product.description??'').toLowerCase();
        return name.contains(query)||description.contains(query);
      }).toList();
    }
    return result;
  }
  void _onBottomTap(int index){
    setState(() {
      _bottomNavIndex=index;
    });
    if (index==0){
      return;
    }
    if (index==1){
      Navigator.pushNamed(context,CategoriesPage.routeName);
      return;
    }
    if (index ==2){
      Navigator.pushNamed(context,BasketPage.routeName);
      return;
    }
    if (index==3){
      Navigator.pushNamed(context,WishlistPage.routeName);
      return;
    }
    if (index==4){
      final user=SessionService.currentUser.value;
      if (user==null){
        Navigator.pushNamed(context,LoginPage.routeName);
        return;
      }
      Navigator.pushNamed(context,AccountPage.routeName);
    }
  }
  Widget _buildLogoArea(){
    return Padding(padding:const EdgeInsets.only(top:16,bottom: 10),
      child:Column(
        children:[
          const SizedBox(height: 6),
          Image.asset('assets/images/1.png',height:80,fit:BoxFit.contain,),
        ],
      ),
    );
  }
  Widget _buildSearchBar(){
    return Container(
      margin:const EdgeInsets.fromLTRB(16,10,16,14),
      height:56,
      decoration:BoxDecoration(
        color:Colors.white,
        borderRadius:BorderRadius.circular(30),
        boxShadow:[BoxShadow(color:Colors.black.withOpacity(0.06),blurRadius:14,offset:const Offset(0,6),),],
      ),
      child:TextField(controller:_searchController,
        decoration:const InputDecoration(
          prefixIcon:Icon(Icons.search,color:Colors.grey,size:28,),
          hintText:"what are you looking for?",
          hintStyle:TextStyle(color:Color(0xFF98A2B3),fontSize:16,),
          border:InputBorder.none,
          contentPadding:EdgeInsets.symmetric(vertical:16),
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product){
    final String imagePath=product.imageUrl??"";
    final bool isFavorite=WishlistService.instance.isInWishlist(product);
    return Container(
      decoration:BoxDecoration(
        color:Colors.white,
        borderRadius:BorderRadius.circular(16),
        boxShadow:[BoxShadow(color:Colors.black.withOpacity(0.05),blurRadius:12,offset:const Offset(0, 8),),],
      ),
      child:Padding(
        padding:const EdgeInsets.all(10),
        child:Column(
          crossAxisAlignment:CrossAxisAlignment.start,
          children:[
            Align(alignment:Alignment.topRight,
              child:IconButton(onPressed:(){WishlistService.instance.toggleProduct(product);
                setState(() {});
                },
                icon:Icon(isFavorite?Icons.favorite :Icons.favorite_border,color:isFavorite ?Colors.red:Colors.grey,),
              ),
            ),
            Expanded(
              child:Container(
                width:double.infinity,
                decoration:BoxDecoration(
                  color:const Color(0xFFF3F4F6),
                  borderRadius:BorderRadius.circular(12),
                ),
                child:imagePath.isNotEmpty?ClipRRect(
                  borderRadius:BorderRadius.circular(12),
                  child:Image.network("${AuthService.baseUrl}$imagePath",fit:BoxFit.cover,),):const Icon(Icons.image_outlined),
              ),
            ),
            const SizedBox(height:10),
            Text(product.name,maxLines:1,overflow:TextOverflow.ellipsis,style:const TextStyle(fontWeight:FontWeight.w600,),),
            const SizedBox(height: 4),
            Text("\$${product.price.toStringAsFixed(0)}",style:const TextStyle(fontWeight:FontWeight.bold,),),
            const SizedBox(height:10),
            SizedBox(
              width:double.infinity,
              height:38,
              child:ElevatedButton(
                onPressed:(){CartService.instance.addProduct({"id":product.id,"name":product.name,"price":product.price,"image":imagePath,});
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("${product.name} added to cart"),duration:const Duration(milliseconds:800),),);
                },
                style:ElevatedButton.styleFrom(
                  backgroundColor:const Color(0xFF111827),
                  foregroundColor:Colors.white,
                  shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(12),),
                ),
                child:const Text("Add to cart"),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildProductsBody(){
    if (_loading){
      return const Expanded(
        child:Center(
          child:CircularProgressIndicator(),
        ),
      );
    }
    if (_error!=null){
      return Expanded(
        child:Center(
          child:Padding(
            padding:const EdgeInsets.all(16),
            child:Text("failed to load home page:\n$_error",textAlign:TextAlign.center,),
          ),
        ),
      );
    }
    final List<Product> products=_filteredProducts;
    if (_selectedTopTabIndex!=0){
      return Expanded(
        child: Center(
          child: Text("i will add it",style: const TextStyle(fontSize:16),),
        ),
      );
    }
    if (products.isEmpty){
      return const Expanded(
        child:Center(
          child:Text("no products found"),
        ),
      );
    }
    return Expanded(
      child:RefreshIndicator(
        onRefresh:_loadProducts,
        child:GridView.builder(
          padding:const EdgeInsets.fromLTRB(16,16,16,16),
          itemCount:products.length,
          gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:2,
            crossAxisSpacing:14,
            mainAxisSpacing:14,
            childAspectRatio:0.62,
          ),
          itemBuilder:(context, index){
            return _buildProductCard(products[index]);
          },
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor:const Color(0xFFF6F7FB),
      body:SafeArea(
        child:Column(
          children:[_buildLogoArea(),_buildSearchBar(),const Divider(height: 1),_buildProductsBody(),],
        ),
      ),
      bottomNavigationBar:AppBottomNav(
        currentIndex:_bottomNavIndex,
        onTap:_onBottomTap,
      ),
    );
  }
}