import 'dart:ui';
import 'package:flutter/material.dart';

const double floatingButtonSize = 85;
const double actionIconSize = floatingButtonSize - 40;

double getHomePageBannerHeight(context) =>
    MediaQuery.of(context).size.height * .7;

double get defaultSafeAreaMarginFromTop =>
    MediaQueryData.fromWindow(window).padding.top + 10;
const double defaultSafeAreaMarginFromRight = 12;
const double defaultSafeAreaMarginFromLeft = 15;
