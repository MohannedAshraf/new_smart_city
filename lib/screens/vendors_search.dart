import 'package:citio/core/utils/assets_image.dart';
import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/models/all_vendors.dart';
import 'package:citio/screens/vendor_profile.dart';
import 'package:citio/services/get_vendor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:get/state_manager.dart';

String _baseUrl = 'https://service-provider.runasp.net';

class VendorsSearch extends StatefulWidget {
  @override
  _VendorSearchState createState() => _VendorSearchState();
}

class _VendorSearchState extends State<VendorsSearch> {
  final TextEditingController _searchController = TextEditingController();
  Future<AllVendor>? _allVendors;
  Future<AllVendor>? _searchedVendors;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _allVendors = GetVendor().getAllVendors();
  }

  Future<void> _fetchVendors() async {
    try {
      setState(() => _isLoading = true);

      final Future<AllVendor> vendors = GetVendor().getAllVendors();

      setState(() {
        _allVendors = vendors;
        _searchedVendors = vendors;
      });
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _searchVendors(String query) {
    setState(() {
      _searchedVendors = GetVendor().searchVendors(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search vendors...',
            border: InputBorder.none,
          ),
          onChanged: (query) {
            if (query.isEmpty) {
              setState(() {
                _searchedVendors = _allVendors;
              });
            } else {
              _searchVendors(query);
            }
          },
        ),
      ),
      body:
          _searchedVendors != null
              ? vendorsList(_searchedVendors!)
              : const Center(child: CircularProgressIndicator()),
    );
  }
}

Widget vendorsList(Future<AllVendor> allVendors) {
  return FutureBuilder<AllVendor>(
    future: allVendors,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        List<Items> vendors = snapshot.data!.items;
        return ListView.builder(
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: vendors.length,
          itemBuilder: (context, index) {
            // ignore: avoid_unnecessary_containers
            return GestureDetector(
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => VendorProfile(
                            cover:
                                vendors[index].coverImage != null
                                    ? _baseUrl + vendors[index].coverImage!
                                    : 'https://cdn-icons-png.flaticon.com/512/13434/13434972.png', // صورة افتراضية
                            profilePic:
                                vendors[index].profileImage != null
                                    ? _baseUrl + vendors[index].profileImage!
                                    : 'https://cdn-icons-png.flaticon.com/128/11820/11820229.png',
                            name:
                                vendors[index].businessName ?? 'اسم غير متوفر',
                            businessType:
                                vendors[index].type ?? 'نوع غير معروف',
                            rating: vendors[index].rating ?? 0.0,
                          ),
                    ),
                  ),
              behavior: HitTestBehavior.opaque,
              child: Card(
                color: MyColors.white,
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Container(
                  // width: double.infinity,
                  height: 200,
                  child: Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        //alignment: Alignment.topRight,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(13),
                              topRight: Radius.circular(13),
                            ),
                            child:
                                vendors[index].coverImage != null
                                    ? Image.network(
                                      _baseUrl + vendors[index].coverImage!,
                                      // vendors[index].coverImage,
                                      width: double.infinity,
                                      height: 120,
                                      fit: BoxFit.cover,
                                      errorBuilder: (
                                        BuildContext context,
                                        Object error,
                                        StackTrace? stackTrace,
                                      ) {
                                        return const SizedBox(
                                          height: 120,
                                          width: double.infinity,
                                          child: Image(
                                            image: AssetImage(
                                              MyAssetsImage.brokenImage,
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                    : Image.asset(
                                      width: double.infinity,
                                      height: 120,
                                      MyAssetsImage.brokenImage,
                                    ),
                          ),
                          Positioned(
                            top: 45,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    0,
                                    8,
                                    20,
                                    0,
                                  ),
                                  child: CircleAvatar(
                                    radius: 40,

                                    backgroundImage:
                                        vendors[index].profileImage != null
                                            ? NetworkImage(
                                              _baseUrl +
                                                  vendors[index].profileImage!,
                                              // vendors[index].profileImage,
                                            )
                                            : const AssetImage(
                                              MyAssetsImage.brokenImage,
                                            ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        0,
                                        5,
                                        20,
                                        10,
                                      ),
                                      child: Text(
                                        vendors[index].businessName,
                                        style: const TextStyle(
                                          color: MyColors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    10,
                                    45,
                                    20,
                                    8,
                                  ),
                                  child: Text(
                                    vendors[index].type,
                                    style: const TextStyle(
                                      color: MyColors.gray,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  10,
                                  45,
                                  20,
                                  8,
                                ),
                                child: StarRating(
                                  size: 20.0,
                                  rating: vendors[index].rating ?? 0,
                                  color: Colors.orange,
                                  borderColor: Colors.grey,
                                  allowHalfRating: true,
                                  starCount: 5,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      //SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    },
  );
}
