//
//  Rects.h
//  iTextReader
//
//  Created by Tetsunari Niina on 2013/09/20.
//  Copyright (c) 2013年 Tetsunari Niina. All rights reserved.
//

#ifndef __RECTS_H_INCLUDED__
#define __RECTS_H_INCLUDED__

static const float kUpGapRatio = 23 / 960.0;
static const float kDownGapRatio = 20 / 960.0;
static const float kLeftGapRatio = 0;
static const float kRightGapRatio = 12 / 720.0;

static const double kShadowXRatio = 0;
static const double kShadowYRatio = 0;
static const double kShadowWidthRatio =  30/720.0;
static const double kShadowHeightRratio = 920/960.0;

static const double kWebviewXRatio = kShadowWidthRatio;
static const double kWebviewYRatio = kShadowYRatio;
static const double kWebviewWidthRatio = 655/720.0;
static const double kWebviewHeightRatio = kShadowHeightRratio;

static const double kPageThicknessXRatio = kShadowWidthRatio+kWebviewWidthRatio;
static const double kPageThicknessYRatio = kDownGapRatio;
static const double kPageThicknessWidthRatio = 28/720.0;
static const double kPageThicknessHeightRatio = kShadowHeightRratio;

#endif