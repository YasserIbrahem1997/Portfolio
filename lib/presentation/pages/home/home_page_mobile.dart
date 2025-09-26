import 'package:flutter/material.dart';
import 'package:Yasser/core/layout/adaptive.dart';
import 'package:Yasser/core/utils/functions.dart';
import 'package:Yasser/presentation/pages/portfolio/portfolio_page.dart';
import 'package:Yasser/presentation/widgets/app_drawer.dart';
import 'package:Yasser/presentation/widgets/circular_container.dart';
import 'package:Yasser/presentation/widgets/content_wrapper.dart';
import 'package:Yasser/presentation/widgets/socials.dart';
import 'package:Yasser/presentation/widgets/spaces.dart';
import 'package:Yasser/values/values.dart';

import '../contact/contact_form_in_web.dart';
import 'home_page.dart';

class HomePageMobile extends StatefulWidget {
  @override
  _HomePageMobileState createState() => _HomePageMobileState();
}

class _HomePageMobileState extends State<HomePageMobile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(
        menuList: Data.menuList,
        selectedItemRouteName: HomePage.homePageRoute,
      ),
      body: Container(
        child: Stack(
          children: [
            // 1. الخلفية والمحتوى الرئيسي (في الأسفل)
            Column(
              children: [
                Row(
                  children: [
                    ContentWrapper(
                      width: assignWidth(context: context, fraction: 0.8),
                      color: AppColors.primaryColor,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: assignHeight(
                                context: context,
                                fraction: 0.2,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 24.0),
                              child: ListBody(
                                children: [
                                  Text(
                                    StringConst.DEV_NAME,
                                    style: theme.textTheme.headlineMedium!.copyWith(
                                      color: AppColors.secondaryColor,
                                    ),
                                  ),
                                  SpaceH8(),
                                  Text(
                                    StringConst.SPECIALITY,
                                    style: theme.textTheme.titleLarge!.copyWith(
                                      color: AppColors.secondaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(flex: 1),

                            // 2. جعل الـ InkWell قابل للنقر بإضافة z-index
                            Container(
                              padding: const EdgeInsets.only(left: 24.0),
                              child: Material( // إضافة Material لتحسين الاستجابة
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    print('Button tapped - Navigating to portfolio');
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => PortfolioPage()),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      RotatedBox(
                                        quarterTurns: 3,
                                        child: Text(
                                          StringConst.VIEW_PORTFOLIO,
                                          textAlign: TextAlign.end,
                                          style: theme.textTheme.bodyLarge!.copyWith(
                                            color: AppColors.secondaryColor,
                                            fontSize: Sizes.TEXT_SIZE_18,
                                          ),
                                        ),
                                      ),
                                      SpaceH12(),
                                      CircularContainer(
                                        width: Sizes.WIDTH_24,
                                        height: Sizes.HEIGHT_24,
                                        color: AppColors.secondaryColor,
                                        child: Icon(
                                          Icons.keyboard_arrow_down,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: assignHeight(
                                context: context,
                                fraction: 0.05,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ContentWrapper(
                      width: assignWidth(context: context, fraction: 0.2),
                      color: AppColors.secondaryColor,
                      child: Container(),
                    ),
                  ],
                )
              ],
            ),

            // 3. الصورة والشبكات الاجتماعية (في الأعلى ولكن غير معيق للنقر)
            _buildDevImage(),
            _buildSocials(),

            // 4. الـ AppBar (في القمة)
            _buildAppBar(),
          ],
        ),
      ),
    );
  }

  // تأكد أن هذه الـ Widgets لا تعيق النقر
  Widget _buildDevImage() {
    return Positioned(
      top: 56,
      right: -assignWidth(context: context, fraction: 0.42),
      child: IgnorePointer( // إضافة هذا لمنع التداخل مع النقر
        child: Container(
          child: Image.asset(
            ImagePath.DEV,
            height: assignHeight(context: context, fraction: 1),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildSocials() {
    return Positioned(
      right: Sizes.SIZE_16,
      bottom: Sizes.SIZE_30,
      child: IgnorePointer( // إضافة هذا لمنع التداخل مع النقر
        child: Socials(
          isVertical: true,
          alignment: Alignment.centerRight,
          color: AppColors.secondaryColor,
          barColor: AppColors.secondaryColor,
          crossAxisAlignment: CrossAxisAlignment.end,
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Positioned( // جعل الـ AppBar في المقدمة
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Sizes.PADDING_16,
          vertical: Sizes.PADDING_16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                if (_scaffoldKey.currentState!.isEndDrawerOpen) {
                  _scaffoldKey.currentState!.openEndDrawer();
                } else {
                  _scaffoldKey.currentState!.openDrawer();
                }
              },
              icon: Icon(Icons.menu),
            ),
            CircularContainer(
              color: AppColors.primaryColor,
              child: InkWell(
                onTap: () {
                  ContactFormDialog.show(context);
                },
                child: Icon(
                  Icons.email,
                  color: AppColors.secondaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}