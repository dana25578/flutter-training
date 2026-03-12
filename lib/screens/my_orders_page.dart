import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../services/order_service.dart';
import '../services/session_service.dart';
import '../services/auth_service.dart';
import 'login_page.dart';
class MyOrdersPage extends StatefulWidget{
  static const String routeName ='/my-orders';
  const MyOrdersPage({super.key});
  @override
  State<MyOrdersPage> createState(){
    return _MyOrdersPageState();
  }
}
class _MyOrdersPageState extends State<MyOrdersPage>{
  bool _loading=true;
  String? _error;
  List<OrderModel> _orders=[];
  @override
  void initState(){
    super.initState();
    _loadOrders();
  }
  Future<void> _loadOrders() async{
    final user=SessionService.currentUser.value;
    if (user==null){
      setState((){
        _loading=false;
      });
      return;
    }
    setState(() {
      _loading=true;
      _error=null;
    });
    try{
      final orders=await OrderService.getOrdersByUser(user.id);
      setState(() {
        _orders=orders;
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
  String _formatDate(String raw){
    if (raw.isEmpty){
      return "";
    }
    try{
      final date=DateTime.parse(raw).toLocal();
      String twoDigits(int n){
        return n.toString().padLeft(2,'0');
      }
      return "${date.year}-${twoDigits(date.month)}-${twoDigits(date.day)}  ${twoDigits(date.hour)}:${twoDigits(date.minute)}";
    } catch (e){
      return raw;
    }
  }
  Widget _guestView(){
    return Center(
      child:Padding(
        padding:const EdgeInsets.all(24),
        child:Container(
          width:double.infinity,
          padding:const EdgeInsets.all(20),
          decoration:BoxDecoration(
            color:Colors.white,
            borderRadius:BorderRadius.circular(18),
          ),
          child:Column(
            mainAxisSize:MainAxisSize.min,
            children:[
              const Icon(Icons.lock_outline,size:42,color:Colors.black87,),
              const SizedBox(height: 14),
              const Text("Login required",style:TextStyle(fontSize:18,fontWeight:FontWeight.w700,),),
              const SizedBox(height: 8),
              const Text("Please login or create an account to view your previous orders.",textAlign:TextAlign.center,
                style:TextStyle(fontSize:14,color:Colors.black87,height:1.4,),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width:double.infinity,
                height:46,
                child:ElevatedButton(
                  onPressed:(){
                    Navigator.pushNamed(context,LoginPage.routeName);
                  },
                  style:ElevatedButton.styleFrom(
                    backgroundColor:Colors.black,
                    foregroundColor:Colors.white,
                    elevation:0,
                    shape:RoundedRectangleBorder(
                      borderRadius:BorderRadius.circular(12),
                    ),
                  ),
                  child:const Text("Go to login"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderItem(OrderItemModel item){
    final String imagePath=item.imageUrl??"";
    return Container(
      margin:const EdgeInsets.only(top:10),
      padding:const EdgeInsets.all(10),
      decoration:BoxDecoration(
        color:const Color(0xFFF8F9FC),
        borderRadius:BorderRadius.circular(14),
      ),
      child:Row(
        children:[
          ClipRRect(
            borderRadius:BorderRadius.circular(12),
            child:Container(
              width:58,
              height:58,
              color:const Color(0xFFF1F3F6),
              child:imagePath.isNotEmpty?Image.network("${AuthService.baseUrl}$imagePath",fit:BoxFit.cover,
                errorBuilder:(context,error,stackTrace) {
                  return const Icon(Icons.image_outlined);
                },
              ):const Icon(Icons.image_outlined),
            ),
          ),
          const SizedBox(width:12),
          Expanded(
            child:Column(
              crossAxisAlignment:CrossAxisAlignment.start,
              children:[
                Text(item.productName,maxLines:1,overflow:TextOverflow.ellipsis,
                  style:const TextStyle(
                    fontWeight:FontWeight.w600,
                    fontSize:14,
                  ),
                ),
                const SizedBox(height:4),
                Text("Quantity:${item.quantity}",style:const TextStyle(color:Colors.black54,fontSize:13,),),
                const SizedBox(height:2),
                Text("Unit price: \$${item.unitPrice.toStringAsFixed(0)}",style:const TextStyle(color:Colors.black54,fontSize:13,),),
              ],
            ),
          ),
          Text("\$${(item.unitPrice * item.quantity).toStringAsFixed(0)}",style:const TextStyle(fontWeight:FontWeight.w700,fontSize:14,),),
        ],
      ),
    );
  }
  Widget _buildOrderCard(OrderModel order){
    final String itemLabel=order.items.length==1?"item":"items";
    return Container(
      margin:const EdgeInsets.only(bottom:14),
      padding:const EdgeInsets.all(16),
      decoration:BoxDecoration(
        color:Colors.white,
        borderRadius:BorderRadius.circular(18),
        boxShadow:[
          BoxShadow(color:Colors.black.withOpacity(0.05),blurRadius:14,offset:const Offset(0, 6),),
        ],
      ),
      child:Column(
        crossAxisAlignment:CrossAxisAlignment.start,
        children:[
          Row(
            children:[
              Container(
                width:42,
                height:42,
                decoration:BoxDecoration(
                  color:const Color(0xFFF7F7F7),
                  borderRadius:BorderRadius.circular(12),
                ),
                child:const Icon(Icons.receipt_long_outlined,color:Colors.black87,
                ),
              ),
              const SizedBox(width:12),
              Expanded(
                child:Column(
                  crossAxisAlignment:CrossAxisAlignment.start,
                  children:[
                    Text("Order #${order.id}",style:const TextStyle(fontSize:16,fontWeight:FontWeight.w700,color:Colors.black,),),
                    const SizedBox(height:3),
                    Text(_formatDate(order.createdAt),style:const TextStyle(fontSize:13,color:Colors.black54,),),
                  ],
                ),
              ),
              Container(
                padding:const EdgeInsets.symmetric(
                  horizontal:10,
                  vertical:6,
                ),decoration:BoxDecoration(
                  color:const Color(0xFFF3F4F6),
                  borderRadius:BorderRadius.circular(12),
                ),
                child:Text("${order.items.length} $itemLabel",style:const TextStyle(fontSize:12,fontWeight:FontWeight.w600,),),
              ),
            ],
          ),
          const SizedBox(height:14),
          Container(
            width:double.infinity,
            padding:const EdgeInsets.all(12),
            decoration:BoxDecoration(
              color:const Color(0xFFF8F9FC),
              borderRadius:BorderRadius.circular(14),
            ),
            child:Row(
              crossAxisAlignment:CrossAxisAlignment.start,
              children:[
                const Icon(Icons.location_on_outlined,size:18,color:Colors.black87,),
                const SizedBox(width:8),
                Expanded(
                  child:Text(order.address,style:const TextStyle(fontSize:14,color:Colors.black87,height:1.35,),),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Text("Items",style:TextStyle(fontSize:15,fontWeight:FontWeight.w700,),),
          const SizedBox(height:6),
          ...order.items.map((item){
            return _buildOrderItem(item);
          }).toList(),
          const SizedBox(height:14),
          const Divider(height:1),
          const SizedBox(height:14),
          Row(
            mainAxisAlignment:MainAxisAlignment.spaceBetween,
            children:[
              const Text("Total",style:TextStyle(fontSize:15,fontWeight:FontWeight.w700,),),
              Text("\$${order.total.toStringAsFixed(0)}",style:const TextStyle(fontSize:16,fontWeight:FontWeight.w800,),),
            ],
          ),
        ],
      ),
    );
  }
  Widget _emptyView(){
    return Center(
      child:Padding(
        padding:const EdgeInsets.all(24),
        child:Container(
          width:double.infinity,
          padding:const EdgeInsets.all(22),
          decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(18),),
          child:const Column(
            mainAxisSize:MainAxisSize.min,
            children:[
              Icon(Icons.inventory_2_outlined,size:44,color:Colors.black87,),
              SizedBox(height:14),
              Text("No orders yet",style:TextStyle(fontSize:18,fontWeight:FontWeight.w700,),),
              SizedBox(height:8),
              Text("your previous orders will appear here after you place your first order",
                textAlign:TextAlign.center,
                style:TextStyle(fontSize:14,color:Colors.black87,height:1.4,),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _errorView(){
    return Center(
      child:Padding(
        padding:const EdgeInsets.all(20),
        child:Column(
          mainAxisSize:MainAxisSize.min,
          children:[
            Text("failed to load orders\n$_error",textAlign:TextAlign.center,style:const TextStyle(fontSize: 14),),
            const SizedBox(height:14),
            ElevatedButton(
              onPressed:_loadOrders,
              style:ElevatedButton.styleFrom(
                backgroundColor:Colors.black,
                foregroundColor:Colors.white,
                shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(12),),
              ),
              child:const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
  Widget _ordersListView(){
    return RefreshIndicator(
      onRefresh:_loadOrders,
      child:ListView.builder(
        padding:const EdgeInsets.all(16),
        itemCount:_orders.length,
        itemBuilder:(context, index){
          return _buildOrderCard(_orders[index]);
        },
      ),
    );
  }
  @override
  Widget build(BuildContext context){
    final user=SessionService.currentUser.value;
    Widget body;
    if (user==null){
      body=_guestView();
    }else if (_loading){
      body=const Center(child:CircularProgressIndicator(),);
    }else if (_error!=null){
      body=_errorView();
    }else if (_orders.isEmpty){
      body=_emptyView();
    }else{
      body=_ordersListView();
    }
    return Scaffold(
      backgroundColor:const Color(0xFFF6F7FB),
      appBar:AppBar(
        backgroundColor:Colors.white,
        foregroundColor:Colors.black,
        elevation:0,
        title: const Text("My orders",style:TextStyle(fontWeight:FontWeight.w600,color:Colors.black,),),
      ),
      body:body,
    );
  }
}