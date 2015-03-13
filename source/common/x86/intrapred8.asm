;*****************************************************************************
;* Copyright (C) 2013 x265 project
;*
;* Authors: Min Chen <chenm003@163.com> <min.chen@multicorewareinc.com>
;*          Praveen Kumar Tiwari <praveen@multicorewareinc.com>
;*
;* This program is free software; you can redistribute it and/or modify
;* it under the terms of the GNU General Public License as published by
;* the Free Software Foundation; either version 2 of the License, or
;* (at your option) any later version.
;*
;* This program is distributed in the hope that it will be useful,
;* but WITHOUT ANY WARRANTY; without even the implied warranty of
;* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;* GNU General Public License for more details.
;*
;* You should have received a copy of the GNU General Public License
;* along with this program; if not, write to the Free Software
;* Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02111, USA.
;*
;* This program is also available under a commercial proprietary license.
;* For more information, contact us at license @ x265.com.
;*****************************************************************************/

%include "x86inc.asm"
%include "x86util.asm"

SECTION_RODATA 32

intra_pred_shuff_0_8:    times 2 db 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8

pb_0_8        times 8 db  0,  8
pb_unpackbw1  times 2 db  1,  8,  2,  8,  3,  8,  4,  8
pb_swap8:     times 2 db  7,  6,  5,  4,  3,  2,  1,  0
c_trans_4x4           db  0,  4,  8, 12,  1,  5,  9, 13,  2,  6, 10, 14,  3,  7, 11, 15
const tab_S1,         db 15, 14, 12, 11, 10,  9,  7,  6,  5,  4,  2,  1,  0,  0,  0,  0
const tab_S2,         db 0, 1, 3, 5, 7, 9, 11, 13, 0, 0, 0, 0, 0, 0, 0, 0
const tab_Si,         db  0,  1,  2,  3,  4,  5,  6,  7,  0,  1,  2,  3,  4,  5,  6,  7
pb_fact0:             db  0,  2,  4,  6,  8, 10, 12, 14,  0,  0,  0,  0,  0,  0,  0,  0
c_mode32_12_0:        db  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 13,  7,  0
c_mode32_13_0:        db  3,  6, 10, 13,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
c_mode32_13_shuf:     db  0,  0,  0,  0,  0,  0,  0,  0,  7,  6,  5,  4,  3,  2,  1,  0
c_mode32_14_shuf:     db 15, 14, 13,  0,  2,  3,  4,  5,  6,  7, 10, 11, 12, 13, 14, 15
c_mode32_14_0:        db 15, 12, 10,  7,  5,  2,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
c_mode32_15_0:        db 15, 13, 11,  9,  8,  6,  4,  2,  0,  0,  0,  0,  0,  0,  0,  0
c_mode32_16_0:        db 15, 14, 12, 11,  9,  8,  6,  5,  3,  2,  0,  0,  0,  0,  0,  0
c_mode32_17_0:        db 15, 14, 12, 11, 10,  9,  7,  6,  5,  4,  2,  1,  0,  0,  0,  0
c_mode32_18_0:        db 15, 14, 13, 12, 11, 10,  9,  8,  7,  6,  5,  4,  3,  2,  1,  0
c_shuf8_0:            db  0,  1,  1,  2,  2,  3,  3,  4,  4,  5,  5,  6,  6,  7,  7,  8
c_deinterval8:        db  0,  8,  1,  9,  2, 10,  3, 11,  4, 12,  5, 13,  6, 14,  7, 15
pb_unpackbq:          db  0,  0,  0,  0,  0,  0,  0,  0,  1,  1,  1,  1,  1,  1,  1,  1
c_mode16_12:    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 13, 6
c_mode16_13:    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 14, 11, 7, 4
c_mode16_14:    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 15, 12, 10, 7, 5, 2
c_mode16_15:          db  0,  0,  0,  0,  0,  0,  0,  0, 15, 13, 11,  9,  8,  6,  4,  2
c_mode16_16:          db  8,  6,  5,  3,  2,  0, 15, 14, 12, 11,  9,  8,  6,  5,  3,  2
c_mode16_17:          db  4,  2,  1,  0, 15, 14, 12, 11, 10,  9,  7,  6,  5,  4,  2,  1
c_mode16_18:    db 0, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1

ALIGN 32
trans8_shuf:          dd 0, 4, 1, 5, 2, 6, 3, 7
c_ang8_src1_9_2_10:   db 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9
c_ang8_26_20:         db 6, 26, 6, 26, 6, 26, 6, 26, 6, 26, 6, 26, 6, 26, 6, 26, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20
c_ang8_src3_11_4_12:  db 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11
c_ang8_14_8:          db 18, 14, 18, 14, 18, 14, 18, 14, 18, 14, 18, 14, 18, 14, 18, 14, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8
c_ang8_src5_13_5_13:  db 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12
c_ang8_2_28:          db 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 4, 28, 4, 28, 4, 28, 4, 28, 4, 28, 4, 28, 4, 28, 4, 28
c_ang8_src6_14_7_15:  db 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14
c_ang8_22_16:         db 10, 22, 10, 22, 10, 22, 10, 22, 10, 22, 10, 22, 10, 22, 10, 22, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16

c_ang8_21_10       :  db 11, 21, 11, 21, 11, 21, 11, 21, 11, 21, 11, 21, 11, 21, 11, 21, 22, 10, 22, 10, 22, 10, 22, 10, 22, 10, 22, 10, 22, 10, 22, 10
c_ang8_src2_10_3_11:  db 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10
c_ang8_31_20:         db 1, 31, 1, 31, 1, 31, 1, 31, 1, 31, 1, 31, 1, 31, 1, 31, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20
c_ang8_src4_12_4_12:  times 2 db 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11
c_ang8_9_30:          db 23, 9, 23, 9, 23, 9, 23, 9, 23, 9, 23, 9, 23, 9, 23, 9, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30
c_ang8_src5_13_6_14:  db 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13
c_ang8_19_8:          db 13, 19, 13, 19, 13, 19, 13, 19, 13, 19, 13, 19, 13, 19, 13, 19, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8

c_ang8_17_2:          db 15, 17, 15, 17, 15, 17, 15, 17, 15, 17, 15, 17, 15, 17, 15, 17, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2
c_ang8_19_4:          db 13, 19, 13, 19, 13, 19, 13, 19, 13, 19, 13, 19, 13, 19, 13, 19, 28, 4, 28, 4, 28, 4, 28, 4, 28, 4, 28, 4, 28, 4, 28, 4
c_ang8_21_6:          db 11, 21, 11, 21, 11, 21, 11, 21, 11, 21, 11, 21, 11, 21, 11, 21, 26, 6, 26, 6, 26, 6, 26, 6, 26, 6, 26, 6, 26, 6, 26, 6
c_ang8_23_8:          db 9, 23, 9, 23, 9, 23, 9, 23, 9, 23, 9, 23, 9, 23, 9, 23, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8,
c_ang8_src4_12_5_13:  db 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12

c_ang8_13_26:         db 19, 13, 19, 13, 19, 13, 19, 13, 19, 13, 19, 13, 19, 13, 19, 13, 6, 26, 6, 26, 6, 26, 6, 26, 6, 26, 6, 26, 6, 26, 6, 26
c_ang8_7_20:          db 25, 7, 25, 7, 25, 7, 25, 7, 25, 7, 25, 7, 25, 7, 25, 7, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20
c_ang8_1_14:          db 31, 1, 31, 1, 31, 1, 31, 1, 31, 1, 31, 1, 31, 1, 31, 1, 18, 14, 18, 14, 18, 14, 18, 14, 18, 14, 18, 14, 18, 14, 18, 14
c_ang8_27_8:          db 5, 27, 5, 27, 5, 27, 5, 27, 5, 27, 5, 27, 5, 27, 5, 27, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8
c_ang8_src2_10_2_10:  db 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9
c_ang8_src3_11_3_11:  db 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10

c_ang8_31_8:          db 1, 31, 1, 31, 1, 31, 1, 31, 1, 31, 1, 31, 1, 31, 1, 31, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8
c_ang8_13_22:         db 19, 13, 19, 13, 19, 13, 19, 13, 19, 13, 19, 13, 19, 13, 19, 13, 10, 22, 10, 22, 10, 22, 10, 22, 10, 22, 10, 22, 10, 22, 10, 22
c_ang8_27_4:          db 5, 27, 5, 27, 5, 27, 5, 27, 5, 27, 5, 27, 5, 27, 5, 27, 28, 4, 28, 4, 28, 4, 28, 4, 28, 4, 28, 4, 28, 4, 28, 4
c_ang8_9_18:          db 23, 9, 23, 9, 23, 9, 23, 9, 23, 9, 23, 9, 23, 9, 23, 9, 14, 18, 14, 18, 14, 18, 14, 18, 14, 18, 14, 18, 14, 18, 14, 18

c_ang8_5_10:          db 27, 5, 27, 5, 27, 5, 27, 5, 27, 5, 27, 5, 27, 5, 27, 5, 22, 10, 22, 10, 22, 10, 22, 10, 22, 10, 22, 10, 22, 10, 22, 10
c_ang8_15_20:         db 17, 15, 17, 15, 17, 15, 17, 15, 17, 15, 17, 15, 17, 15, 17, 15, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20
c_ang8_25_30:         db 7, 25, 7, 25, 7, 25, 7, 25, 7, 25, 7, 25, 7, 25, 7, 25, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30
c_ang8_3_8:           db 29, 3, 29, 3, 29, 3, 29, 3, 29, 3, 29, 3, 29, 3, 29, 3, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8

c_ang8_mode_27:       db 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 28, 4, 28, 4, 28, 4, 28, 4, 28, 4, 28, 4, 28, 4, 28, 4
                      db 26, 6, 26, 6, 26, 6, 26, 6, 26, 6, 26, 6, 26, 6, 26, 6, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8
                      db 22, 10, 22, 10, 22, 10, 22, 10, 22, 10, 22, 10, 22, 10, 22, 10, 20, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20, 12
                      db 18, 14, 18, 14, 18, 14, 18, 14, 18, 14, 18, 14, 18, 14, 18, 14, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16

c_ang8_mode_25:       db 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 4, 28, 4, 28, 4, 28, 4, 28, 4, 28, 4, 28, 4, 28, 4, 28
                      db 6, 26, 6, 26, 6, 26, 6, 26, 6, 26, 6, 26, 6, 26, 6, 26, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24
                      db 10, 22, 10, 22, 10, 22, 10, 22, 10, 22, 10, 22, 10, 22, 10, 22, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20
                      db 14, 18, 14, 18, 14, 18, 14, 18, 14, 18, 14, 18, 14, 18, 14, 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16

c_ang8_mode_24:       db 5, 27, 5, 27, 5, 27, 5, 27, 5, 27, 5, 27, 5, 27, 5, 27, 10, 22, 10, 22, 10, 22, 10, 22, 10, 22, 10, 22, 10, 22, 10, 22
                      db 15, 17, 15, 17, 15, 17, 15, 17, 15, 17, 15, 17, 15, 17, 15, 17, 20, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20, 12
                      db 25, 7, 25, 7, 25, 7, 25, 7, 25, 7, 25, 7, 25, 7, 25, 7, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2
                      db 3, 29, 3, 29, 3, 29, 3, 29, 3, 29, 3, 29, 3, 29, 3, 29, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24

ALIGN 32
c_ang16_mode_25:      db 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 4, 28, 4, 28, 4, 28, 4, 28, 4, 28, 4, 28, 4, 28, 4, 28
                      db 6, 26, 6, 26, 6, 26, 6, 26, 6, 26, 6, 26, 6, 26, 6, 26, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24
                      db 10, 22, 10, 22, 10, 22, 10, 22, 10, 22, 10, 22, 10, 22, 10, 22, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20
                      db 14, 18, 14, 18, 14, 18, 14, 18, 14, 18, 14, 18, 14, 18, 14, 18, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16
                      db 18, 14, 18, 14, 18, 14, 18, 14, 18, 14, 18, 14, 18, 14, 18, 14, 20, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20, 12
                      db 22, 10, 22, 10, 22, 10, 22, 10, 22, 10, 22, 10, 22, 10, 22, 10, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8
                      db 26, 6, 26, 6, 26, 6, 26, 6, 26, 6, 26, 6, 26, 6, 26, 6, 28, 4, 28, 4, 28, 4, 28, 4, 28, 4, 28, 4, 28, 4, 28, 4
                      db 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 32, 0, 32, 0, 32, 0, 32, 0, 32, 0, 32, 0, 32, 0, 32, 0


ALIGN 32
c_ang16_mode_28:      db 27, 5, 27, 5, 27, 5, 27, 5, 27, 5, 27, 5, 27, 5, 27, 5, 22, 10, 22, 10, 22, 10, 22, 10, 22, 10, 22, 10, 22, 10, 22, 10
                      db 17, 15, 17, 15, 17, 15, 17, 15, 17, 15, 17, 15, 17, 15, 17, 15, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20
                      db 7, 25, 7, 25, 7, 25, 7, 25, 7, 25, 7, 25, 7, 25, 7, 25, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30
                      db 29, 3, 29, 3, 29, 3, 29, 3, 29, 3, 29, 3, 29, 3, 29, 3, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8
                      db 19, 13, 19, 13, 19, 13, 19, 13, 19, 13, 19, 13, 19, 13, 19, 13, 14, 18, 14, 18, 14, 18, 14, 18, 14, 18, 14, 18, 14, 18, 14, 18
                      db 9, 23, 9, 23, 9, 23, 9, 23, 9, 23, 9, 23, 9, 23, 9, 23, 4, 28, 4, 28, 4, 28, 4, 28, 4, 28, 4, 28, 4, 28, 4, 28
                      db 31, 1, 31, 1, 31, 1, 31, 1, 31, 1, 31, 1, 31, 1, 31, 1, 26, 6, 26, 6, 26, 6, 26, 6, 26, 6, 26, 6, 26, 6, 26, 6
                      db 21, 11, 21, 11, 21, 11, 21, 11, 21, 11, 21, 11, 21, 11, 21, 11, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16


ALIGN 32
c_ang16_mode_27:      db 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 28, 4, 28, 4, 28, 4, 28, 4, 28, 4, 28, 4, 28, 4, 28, 4
                      db 26, 6, 26, 6, 26, 6, 26, 6, 26, 6, 26, 6, 26, 6, 26, 6, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8
                      db 22, 10, 22, 10, 22, 10, 22, 10, 22, 10, 22, 10, 22, 10, 22, 10, 20, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20, 12
                      db 18, 14, 18, 14, 18, 14, 18, 14, 18, 14, 18, 14, 18, 14, 18, 14, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16
                      db 14, 18, 14, 18, 14, 18, 14, 18, 14, 18, 14, 18, 14, 18, 14, 18, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20
                      db 10, 22, 10, 22, 10, 22, 10, 22, 10, 22, 10, 22, 10, 22, 10, 22, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24
                      db 6, 26, 6, 26, 6, 26, 6, 26, 6, 26, 6, 26, 6, 26, 6, 26, 4, 28, 4, 28, 4, 28, 4, 28, 4, 28, 4, 28, 4, 28, 4, 28
                      db 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30
                      db 32, 0, 32, 0, 32, 0, 32, 0, 32, 0, 32, 0, 32, 0, 32, 0, 32, 0, 32, 0, 32, 0, 32, 0, 32, 0, 32, 0, 32, 0, 32, 0

ALIGN 32
intra_pred_shuff_0_15: db 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15, 15


ALIGN 32
c_ang16_mode_29:     db 23, 9, 23, 9, 23, 9, 23, 9, 23, 9, 23, 9, 23, 9, 23, 9,  14, 18, 14, 18, 14, 18, 14, 18, 14, 18, 14, 18, 14, 18, 14, 18
                     db 5, 27, 5, 27, 5, 27, 5, 27, 5, 27, 5, 27, 5, 27, 5, 27, 5, 27, 5, 27, 5, 27, 5, 27, 5, 27, 5, 27, 5, 27, 5, 27
                     db 28, 4, 28, 4, 28, 4, 28, 4, 28, 4, 28, 4, 28, 4, 28, 4, 19, 13, 19, 13, 19, 13, 19, 13, 19, 13, 19, 13, 19, 13, 19, 13
                     db 10, 22, 10, 22, 10, 22, 10, 22, 10, 22, 10, 22, 10, 22, 10, 22, 1, 31, 1, 31, 1, 31, 1, 31, 1, 31, 1, 31, 1, 31, 1, 31
                     db 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 24, 8, 15, 17, 15, 17, 15, 17, 15, 17, 15, 17, 15, 17, 15, 17, 15, 17
                     db 6, 26, 6, 26, 6, 26, 6, 26, 6, 26, 6, 26, 6, 26, 6, 26, 6, 26, 6, 26, 6, 26, 6, 26, 6, 26, 6, 26, 6, 26, 6, 26
                     db 29, 3, 29, 3, 29, 3, 29, 3, 29, 3, 29, 3, 29, 3, 29, 3, 20, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20, 12, 20, 12
                     db 11, 21, 11, 21, 11, 21, 11, 21, 11, 21, 11, 21, 11, 21, 11, 21, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30, 2, 30
                     db 25, 7, 25, 7, 25, 7, 25, 7, 25, 7, 25, 7, 25, 7, 25, 7, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16

ALIGN 32
;; (blkSize - 1 - x)
pw_planar4_0:         dw 3,  2,  1,  0,  3,  2,  1,  0
pw_planar4_1:         dw 3,  3,  3,  3,  3,  3,  3,  3
pw_planar8_0:         dw 7,  6,  5,  4,  3,  2,  1,  0
pw_planar8_1:         dw 7,  7,  7,  7,  7,  7,  7,  7
pw_planar16_0:        dw 15, 14, 13, 12, 11, 10, 9,  8
pw_planar16_1:        dw 15, 15, 15, 15, 15, 15, 15, 15
pw_planar32_1:        dw 31, 31, 31, 31, 31, 31, 31, 31
pw_planar32_L:        dw 31, 30, 29, 28, 27, 26, 25, 24
pw_planar32_H:        dw 23, 22, 21, 20, 19, 18, 17, 16


const ang_table
%assign x 0
%rep 32
    times 8 db (32-x), x
%assign x x+1
%endrep

SECTION .text

cextern pw_2
cextern pw_4
cextern pw_8
cextern pw_16
cextern pw_32
cextern pw_257
cextern pw_1024
cextern pw_4096
cextern pw_00ff
cextern pb_unpackbd1
cextern multiL
cextern multiH
cextern multiH2
cextern multiH3
cextern multi_2Row

;---------------------------------------------------------------------------------------------
; void intra_pred_dc(pixel* dst, intptr_t dstStride, pixel *srcPix, int dirMode, int bFilter)
;---------------------------------------------------------------------------------------------
INIT_XMM sse2
cglobal intra_pred_dc4, 5,5,3
    inc         r2
    pxor        m0, m0
    movu        m1, [r2]
    pshufd      m1, m1, 0xF8
    psadbw      m1, m0              ; m1 = sum

    test        r4d, r4d

    paddw       m1, [pw_4]
    psraw       m1, 3
    movd        r4d, m1             ; r4d = dc_val
    pmullw      m1, [pw_257]
    pshuflw     m1, m1, 0x00

    ; store DC 4x4
    lea         r3, [r1 * 3]
    movd        [r0], m1
    movd        [r0 + r1], m1
    movd        [r0 + r1 * 2], m1
    movd        [r0 + r3], m1

    ; do DC filter
    jz         .end
    lea         r3d, [r4d * 2 + 2]  ; r3d = DC * 2 + 2
    add         r4d, r3d            ; r4d = DC * 3 + 2
    movd        m1, r4d
    pshuflw     m1, m1, 0           ; m1 = pixDCx3

    ; filter top
    movd        m2, [r2]
    punpcklbw   m2, m0
    paddw       m2, m1
    psraw       m2, 2
    packuswb    m2, m2
    movd        [r0], m2            ; overwrite top-left pixel, we will update it later

    ; filter top-left
    movzx       r4d, byte [r2 + 8]
    add         r3d, r4d
    movzx       r4d, byte [r2]
    add         r3d, r4d
    shr         r3d, 2
    mov         [r0], r3b

    ; filter left
    add         r0, r1
    movq        m2, [r2 + 9]
    punpcklbw   m2, m0
    paddw       m2, m1
    psraw       m2, 2
    packuswb    m2, m2
%if ARCH_X86_64
    movq        r4, m2
    mov         [r0], r4b
    shr         r4, 8
    mov         [r0 + r1], r4b
    shr         r4, 8
    mov         [r0 + r1 * 2], r4b
%else
    movd        r2d, m2
    mov         [r0], r2b
    shr         r2, 8
    mov         [r0 + r1], r2b
    shr         r2, 8
    mov         [r0 + r1 * 2], r2b
%endif
.end:
    RET

;---------------------------------------------------------------------------------------------
; void intra_pred_dc(pixel* dst, intptr_t dstStride, pixel *srcPix, int dirMode, int bFilter)
;---------------------------------------------------------------------------------------------
INIT_XMM sse2
cglobal intra_pred_dc8, 5, 7, 3
    pxor            m0,            m0
    movh            m1,            [r2 + 1]
    movh            m2,            [r2 + 17]
    punpcklqdq      m1,            m2
    psadbw          m1,            m0
    pshufd          m2,            m1, 2
    paddw           m1,            m2

    paddw           m1,            [pw_8]
    psraw           m1,            4
    pmullw          m1,            [pw_257]
    pshuflw         m1,            m1, 0x00       ; m1 = byte [dc_val ...]

    test            r4d,           r4d

    ; store DC 8x8
    lea             r6,            [r1 + r1 * 2]
    lea             r5,            [r6 + r1 * 2]
    movh            [r0],          m1
    movh            [r0 + r1],     m1
    movh            [r0 + r1 * 2], m1
    movh            [r0 + r6],     m1
    movh            [r0 + r1 * 4], m1
    movh            [r0 + r5],     m1
    movh            [r0 + r6 * 2], m1
    lea             r5,            [r5 + r1 * 2]
    movh            [r0 + r5],     m1

    ; Do DC Filter
    jz              .end
    psrlw           m1,            8
    movq            m2,            [pw_2]
    pmullw          m2,            m1
    paddw           m2,            [pw_2]
    movd            r4d,           m2             ; r4d = DC * 2 + 2
    paddw           m1,            m2             ; m1 = DC * 3 + 2
    pshufd          m1,            m1, 0

    ; filter top
    movq            m2,            [r2 + 1]
    punpcklbw       m2,            m0
    paddw           m2,            m1
    psraw           m2,            2              ; sum = sum / 16
    packuswb        m2,            m2
    movh            [r0],          m2

    ; filter top-left
    movzx           r3d, byte      [r2 + 17]
    add             r4d,           r3d
    movzx           r3d, byte      [r2 + 1]
    add             r3d,           r4d
    shr             r3d,           2
    mov             [r0],          r3b

    ; filter left
    movq            m2,            [r2 + 18]
    punpcklbw       m2,            m0
    paddw           m2,            m1
    psraw           m2,            2
    packuswb        m2,            m2
    movd            r2d,           m2
    lea             r0,            [r0 + r1]
    lea             r5,            [r6 + r1 * 2]
    mov             [r0],          r2b
    shr             r2,            8
    mov             [r0 + r1],     r2b
    shr             r2,            8
    mov             [r0 + r1 * 2], r2b
    shr             r2,            8
    mov             [r0 + r6],     r2b
    pshufd          m2,            m2, 0x01
    movd            r2d,           m2
    mov             [r0 + r1 * 4], r2b
    shr             r2,            8
    mov             [r0 + r5],     r2b
    shr             r2,            8
    mov             [r0 + r6 * 2], r2b

.end:
    RET

;--------------------------------------------------------------------------------------------
; void intra_pred_dc(pixel* dst, intptr_t dstStride, pixel *srcPix, int dirMode, int bFilter)
;--------------------------------------------------------------------------------------------
INIT_XMM sse2
%if ARCH_X86_64
cglobal intra_pred_dc16, 5, 10, 4
%else
cglobal intra_pred_dc16, 5, 7, 4
%endif
    pxor            m0,            m0
    movu            m1,            [r2 + 1]
    movu            m2,            [r2 + 33]
    psadbw          m1,            m0
    psadbw          m2,            m0
    paddw           m1,            m2
    pshufd          m2,            m1, 2
    paddw           m1,            m2

    paddw           m1,            [pw_16]
    psraw           m1,            5
    pmullw          m1,            [pw_257]
    pshuflw         m1,            m1, 0x00       ; m1 = byte [dc_val ...]
    pshufd          m1,            m1, 0x00


    test            r4d,           r4d

    ; store DC 16x16
%if ARCH_X86_64
    lea             r6,            [r1 + r1 * 2]        ;index 3
    lea             r7,            [r1 + r1 * 4]        ;index 5
    lea             r8,            [r6 + r1 * 4]        ;index 7
    lea             r9,            [r0 + r8]            ;base + 7
    movu            [r0],          m1
    movu            [r0 + r1],     m1
    movu            [r0 + r1 * 2], m1
    movu            [r0 + r6],     m1
    movu            [r0 + r1 * 4], m1
    movu            [r0 + r7],     m1
    movu            [r0 + r6 * 2], m1
    movu            [r0 + r8],     m1
    movu            [r0 + r1 * 8], m1
    movu            [r9 + r1 * 2], m1
    movu            [r0 + r7 * 2], m1
    movu            [r9 + r1 * 4], m1
    movu            [r0 + r6 * 4], m1
    movu            [r9 + r6 * 2], m1
    movu            [r0 + r8 * 2], m1
    movu            [r9 + r1 * 8], m1
%else ;32 bit
    mov             r6,            r0
    movu            [r0],          m1
    movu            [r0 + r1],     m1
    lea             r0,            [r0 + r1 * 2]
    movu            [r0],          m1
    movu            [r0 + r1],     m1
    lea             r0,            [r0 + r1 * 2]
    movu            [r0],          m1
    movu            [r0 + r1],     m1
    lea             r0,            [r0 + r1 * 2]
    movu            [r0],          m1
    movu            [r0 + r1],     m1
    lea             r0,            [r0 + r1 * 2]
    movu            [r0],          m1
    movu            [r0 + r1],     m1
    lea             r0,            [r0 + r1 * 2]
    movu            [r0],          m1
    movu            [r0 + r1],     m1
    lea             r0,            [r0 + r1 * 2]
    movu            [r0],          m1
    movu            [r0 + r1],     m1
    lea             r0,            [r0 + r1 * 2]
    movu            [r0],          m1
    movu            [r0 + r1],     m1
%endif
    ; Do DC Filter
    jz              .end
    psrlw           m1,            8
    mova            m2,            [pw_2]
    pmullw          m2,            m1
    paddw           m2,            [pw_2]
    movd            r4d,           m2
    paddw           m1,            m2

    ; filter top
    movh            m2,            [r2 + 1]
    punpcklbw       m2,            m0
    paddw           m2,            m1
    psraw           m2,            2
    packuswb        m2,            m2
    movh            m3,            [r2 + 9]
    punpcklbw       m3,            m0
    paddw           m3,            m1
    psraw           m3,            2
    packuswb        m3,            m3

    ; filter top-left
    movzx           r5d, byte      [r2 + 33]
    add             r4d,           r5d
    movzx           r3d, byte      [r2 + 1]
    add             r3d,           r4d
    shr             r3d,           2

%if ARCH_X86_64
    movh            [r0],          m2
    movh            [r0 + 8],      m3
    mov             [r0],          r3b
%else ;32 bit
    movh            [r6],          m2
    movh            [r6 + 8],      m3
    mov             [r6],          r3b
    add             r6,            r1
%endif

    ; filter left
    movh            m2,            [r2 + 34]
    punpcklbw       m2,            m0
    paddw           m2,            m1
    psraw           m2,            2
    packuswb        m2,            m2

    movh            m3,            [r2 + 42]
    punpcklbw       m3,            m0
    paddw           m3,            m1
    psraw           m3,            2
    packuswb        m3,            m3
%if ARCH_X86_64
    movh            r3,            m2
    mov             [r0 + r1],     r3b
    shr             r3,            8
    mov             [r0 + r1 * 2], r3b
    shr             r3,            8
    mov             [r0 + r6],     r3b
    shr             r3,            8
    mov             [r0 + r1 * 4], r3b
    shr             r3,            8
    mov             [r0 + r7],     r3b
    shr             r3,            8
    mov             [r0 + r6 * 2], r3b
    shr             r3,            8
    mov             [r0 + r8],     r3b
    shr             r3,            8
    mov             [r0 + r1 * 8], r3b
    movh            r3,            m3
    mov             [r9 + r1 * 2], r3b
    shr             r3,            8
    mov             [r0 + r7 * 2], r3b
    shr             r3,            8
    mov             [r9 + r1 * 4], r3b
    shr             r3,            8
    mov             [r0 + r6 * 4], r3b
    shr             r3,            8
    mov             [r9 + r6 * 2], r3b
    shr             r3,            8
    mov             [r0 + r8 * 2], r3b
    shr             r3,            8
    mov             [r9 + r1 * 8], r3b
%else ;32 bit
    movd            r2d,            m2
    pshufd          m2,            m2, 0x01
    mov             [r6],          r2b
    shr             r2,            8
    mov             [r6 + r1],     r2b
    shr             r2,            8
    mov             [r6 + r1 * 2], r2b
    lea             r6,            [r6 + r1 * 2]
    shr             r2,            8
    mov             [r6 + r1],     r2b
    movd            r2d,           m2
    mov             [r6 + r1 * 2], r2b
    lea             r6,            [r6 + r1 * 2]
    shr             r2,            8
    mov             [r6 + r1],     r2b
    shr             r2,            8
    mov             [r6 + r1 * 2], r2b
    lea             r6,            [r6 + r1 * 2]
    shr             r2,            8
    mov             [r6 + r1],     r2b
    movd            r2d,            m3
    pshufd          m3,             m3, 0x01
    mov             [r6 + r1 * 2], r2b
    lea             r6,            [r6 + r1 * 2]
    shr             r2,            8
    mov             [r6 + r1],     r2b
    shr             r2,            8
    mov             [r6 + r1 * 2], r2b
    lea             r6,            [r6 + r1 * 2]
    shr             r2,            8
    mov             [r6 + r1],     r2b
    movd            r2d,           m3
    mov             [r6 + r1 * 2], r2b
    lea             r6,            [r6 + r1 * 2]
    shr             r2,            8
    mov             [r6 + r1],     r2b
    shr             r2,            8
    mov             [r6 + r1 * 2], r2b
%endif
.end:
    RET

;---------------------------------------------------------------------------------------------
; void intra_pred_dc(pixel* dst, intptr_t dstStride, pixel *srcPix, int dirMode, int bFilter)
;---------------------------------------------------------------------------------------------
INIT_XMM sse2
cglobal intra_pred_dc32, 3, 3, 5
    pxor            m0,            m0
    movu            m1,            [r2 + 1]
    movu            m2,            [r2 + 17]
    movu            m3,            [r2 + 65]
    movu            m4,            [r2 + 81]
    psadbw          m1,            m0
    psadbw          m2,            m0
    psadbw          m3,            m0
    psadbw          m4,            m0
    paddw           m1,            m2
    paddw           m3,            m4
    paddw           m1,            m3
    pshufd          m2,            m1, 2
    paddw           m1,            m2

    paddw           m1,            [pw_32]
    psraw           m1,            6
    pmullw          m1,            [pw_257]
    pshuflw         m1,            m1, 0x00       ; m1 = byte [dc_val ...]
    pshufd          m1,            m1, 0x00

%assign x 0
%rep 16
    ; store DC 16x16
    movu            [r0],               m1
    movu            [r0 + r1],          m1
    movu            [r0 + 16],          m1
    movu            [r0 + r1 + 16],     m1
%if x < 16
    lea             r0,            [r0 + 2 * r1]
%endif
%assign x x+1
%endrep
    RET

;---------------------------------------------------------------------------------------
; void intra_pred_planar(pixel* dst, intptr_t dstStride, pixel*srcPix, int, int filter)
;---------------------------------------------------------------------------------------
INIT_XMM sse2
cglobal intra_pred_planar4, 3,3,5
    pxor            m0, m0
    movh            m1, [r2 + 1]
    punpcklbw       m1, m0
    movh            m2, [r2 + 9]
    punpcklbw       m2, m0
    pshufhw         m3, m1, 0               ; topRight
    pshufd          m3, m3, 0xAA
    pshufhw         m4, m2, 0               ; bottomLeft
    pshufd          m4, m4, 0xAA

    pmullw          m3, [multi_2Row]        ; (x + 1) * topRight
    pmullw          m0, m1, [pw_planar4_1]  ; (blkSize - 1 - y) * above[x]
    paddw           m3, [pw_4]
    paddw           m3, m4
    paddw           m3, m0
    psubw           m4, m1

    pshuflw         m1, m2, 0
    pmullw          m1, [pw_planar4_0]
    paddw           m1, m3
    paddw           m3, m4
    psraw           m1, 3
    packuswb        m1, m1
    movd            [r0], m1

    pshuflw         m1, m2, 01010101b
    pmullw          m1, [pw_planar4_0]
    paddw           m1, m3
    paddw           m3, m4
    psraw           m1, 3
    packuswb        m1, m1
    movd            [r0 + r1], m1
    lea             r0, [r0 + 2 * r1]

    pshuflw         m1, m2, 10101010b
    pmullw          m1, [pw_planar4_0]
    paddw           m1, m3
    paddw           m3, m4
    psraw           m1, 3
    packuswb        m1, m1
    movd            [r0], m1

    pshuflw         m1, m2, 11111111b
    pmullw          m1, [pw_planar4_0]
    paddw           m1, m3
    psraw           m1, 3
    packuswb        m1, m1
    movd            [r0 + r1], m1
    RET

;---------------------------------------------------------------------------------------
; void intra_pred_planar(pixel* dst, intptr_t dstStride, pixel*srcPix, int, int filter)
;---------------------------------------------------------------------------------------
INIT_XMM sse2
cglobal intra_pred_planar8, 3,3,6
    pxor            m0, m0
    movh            m1, [r2 + 1]
    punpcklbw       m1, m0
    movh            m2, [r2 + 17]
    punpcklbw       m2, m0

    movd            m3, [r2 + 9]            ; topRight   = above[8];
    movd            m4, [r2 + 25]           ; bottomLeft = left[8];

    pand            m3, [pw_00ff]
    pand            m4, [pw_00ff]
    pshuflw         m3, m3, 0x00
    pshuflw         m4, m4, 0x00
    pshufd          m3, m3, 0x44
    pshufd          m4, m4, 0x44

    pmullw          m3, [multiL]            ; (x + 1) * topRight
    pmullw          m0, m1, [pw_planar8_1]  ; (blkSize - 1 - y) * above[x]
    paddw           m3, [pw_8]
    paddw           m3, m4
    paddw           m3, m0
    psubw           m4, m1

%macro INTRA_PRED_PLANAR_8 1
%if (%1 < 4)
    pshuflw         m5, m2, 0x55 * %1
    pshufd          m5, m5, 0
%else
    pshufhw         m5, m2, 0x55 * (%1 - 4)
    pshufd          m5, m5, 0xAA
%endif
    pmullw          m5, [pw_planar8_0]
    paddw           m5, m3
    psraw           m5, 4
    packuswb        m5, m5
    movh            [r0], m5
%if (%1 < 7)
    paddw           m3, m4
    lea             r0, [r0 + r1]
%endif
%endmacro

    INTRA_PRED_PLANAR_8 0
    INTRA_PRED_PLANAR_8 1
    INTRA_PRED_PLANAR_8 2
    INTRA_PRED_PLANAR_8 3
    INTRA_PRED_PLANAR_8 4
    INTRA_PRED_PLANAR_8 5
    INTRA_PRED_PLANAR_8 6
    INTRA_PRED_PLANAR_8 7
    RET

;---------------------------------------------------------------------------------------
; void intra_pred_planar(pixel* dst, intptr_t dstStride, pixel*srcPix, int, int filter)
;---------------------------------------------------------------------------------------
INIT_XMM sse2
cglobal intra_pred_planar16, 3,5,8
    pxor            m0, m0
    movh            m2, [r2 + 1]
    punpcklbw       m2, m0
    movh            m7, [r2 + 9]
    punpcklbw       m7, m0

    movd            m3, [r2 + 17]               ; topRight   = above[16]
    movd            m6, [r2 + 49]               ; bottomLeft = left[16]
    pand            m3, [pw_00ff]
    pand            m6, [pw_00ff]
    pshuflw         m3, m3, 0x00
    pshuflw         m6, m6, 0x00
    pshufd          m3, m3, 0x44                ; v_topRight
    pshufd          m6, m6, 0x44                ; v_bottomLeft

    pmullw          m4, m3, [multiH]            ; (x + 1) * topRight
    pmullw          m3, [multiL]                ; (x + 1) * topRight
    pmullw          m1, m2, [pw_planar16_1]     ; (blkSize - 1 - y) * above[x]
    pmullw          m5, m7, [pw_planar16_1]     ; (blkSize - 1 - y) * above[x]
    paddw           m4, [pw_16]
    paddw           m3, [pw_16]
    paddw           m4, m6
    paddw           m3, m6
    paddw           m4, m5
    paddw           m3, m1
    psubw           m1, m6, m7
    psubw           m6, m2

    movh            m2, [r2 + 33]
    punpcklbw       m2, m0
    movh            m7, [r2 + 41]
    punpcklbw       m7, m0

%macro INTRA_PRED_PLANAR_16 1
%if (%1 < 4)
    pshuflw         m5, m2, 0x55 * %1
    pshufd          m5, m5, 0
%else
%if (%1 < 8)
    pshufhw         m5, m2, 0x55 * (%1 - 4)
    pshufd          m5, m5, 0xAA
%else
%if (%1 < 12)
    pshuflw         m5, m7, 0x55 * (%1 - 8)
    pshufd          m5, m5, 0
%else
    pshufhw         m5, m7, 0x55 * (%1 - 12)
    pshufd          m5, m5, 0xAA
%endif
%endif
%endif
%if (%1 > 0)
    paddw           m3, m6
    paddw           m4, m1
    lea             r0, [r0 + r1]
%endif
    pmullw          m0, m5, [pw_planar8_0]
    pmullw          m5, [pw_planar16_0]
    paddw           m0, m4
    paddw           m5, m3
    psraw           m5, 5
    psraw           m0, 5
    packuswb        m5, m0
    movu            [r0], m5
%endmacro

    INTRA_PRED_PLANAR_16 0
    INTRA_PRED_PLANAR_16 1
    INTRA_PRED_PLANAR_16 2
    INTRA_PRED_PLANAR_16 3
    INTRA_PRED_PLANAR_16 4
    INTRA_PRED_PLANAR_16 5
    INTRA_PRED_PLANAR_16 6
    INTRA_PRED_PLANAR_16 7
    INTRA_PRED_PLANAR_16 8
    INTRA_PRED_PLANAR_16 9
    INTRA_PRED_PLANAR_16 10
    INTRA_PRED_PLANAR_16 11
    INTRA_PRED_PLANAR_16 12
    INTRA_PRED_PLANAR_16 13
    INTRA_PRED_PLANAR_16 14
    INTRA_PRED_PLANAR_16 15
    RET

;---------------------------------------------------------------------------------------
; void intra_pred_planar(pixel* dst, intptr_t dstStride, pixel*srcPix, int, int filter)
;---------------------------------------------------------------------------------------
INIT_XMM sse2
%if ARCH_X86_64 == 1
cglobal intra_pred_planar32, 3,3,16
    movd            m3, [r2 + 33]               ; topRight   = above[32]

    pxor            m7, m7
    pand            m3, [pw_00ff]
    pshuflw         m3, m3, 0x00
    pshufd          m3, m3, 0x44

    pmullw          m0, m3, [multiL]            ; (x + 1) * topRight
    pmullw          m1, m3, [multiH]            ; (x + 1) * topRight
    pmullw          m2, m3, [multiH2]           ; (x + 1) * topRight
    pmullw          m3, [multiH3]               ; (x + 1) * topRight

    movd            m11, [r2 + 97]               ; bottomLeft = left[32]
    pand            m11, [pw_00ff]
    pshuflw         m11, m11, 0x00
    pshufd          m11, m11, 0x44
    mova            m5,  m11
    paddw           m5,  [pw_32]

    paddw           m0, m5
    paddw           m1, m5
    paddw           m2, m5
    paddw           m3, m5
    mova            m8, m11
    mova            m9, m11
    mova            m10, m11

    mova            m12, [pw_planar32_1]
    movh            m4, [r2 + 1]
    punpcklbw       m4, m7
    psubw           m8, m4
    pmullw          m4, m12
    paddw           m0, m4

    movh            m4, [r2 + 9]
    punpcklbw       m4, m7
    psubw           m9, m4
    pmullw          m4, m12
    paddw           m1, m4

    movh            m4, [r2 + 17]
    punpcklbw       m4, m7
    psubw           m10, m4
    pmullw          m4, m12
    paddw           m2, m4

    movh            m4, [r2 + 25]
    punpcklbw       m4, m7
    psubw           m11, m4
    pmullw          m4, m12
    paddw           m3, m4

    mova            m12, [pw_planar32_L]
    mova            m13, [pw_planar32_H]
    mova            m14, [pw_planar16_0]
    mova            m15, [pw_planar8_0]
%macro PROCESS 1
    pmullw          m5, %1, m12
    pmullw          m6, %1, m13
    paddw           m5, m0
    paddw           m6, m1
    psraw           m5, 6
    psraw           m6, 6
    packuswb        m5, m6
    movu            [r0], m5

    pmullw          m5, %1, m14
    pmullw          %1, m15
    paddw           m5, m2
    paddw           %1, m3
    psraw           m5, 6
    psraw           %1, 6
    packuswb        m5, %1
    movu            [r0 + 16], m5
%endmacro

%macro INCREMENT 0
    paddw           m2, m10
    paddw           m3, m11
    paddw           m0, m8
    paddw           m1, m9
    add             r0, r1
%endmacro

%assign x 0
%rep 4
    pxor            m7, m7
    movq            m4, [r2 + 65 + x * 8]
    punpcklbw       m4, m7
%assign y 0
%rep 8
    %if y < 4
    pshuflw         m7, m4, 0x55 * y
    pshufd          m7, m7, 0x44
    %else
    pshufhw         m7, m4, 0x55 * (y - 4)
    pshufd          m7, m7, 0xEE
    %endif
    PROCESS m7
    %if x + y < 10
    INCREMENT
    %endif
%assign y y+1
%endrep
%assign x x+1
%endrep
    RET

%else ;end ARCH_X86_64, start ARCH_X86_32
cglobal intra_pred_planar32, 3,3,8,0-(4*mmsize)
    movd            m3, [r2 + 33]               ; topRight   = above[32]

    pxor            m7, m7
    pand            m3, [pw_00ff]
    pshuflw         m3, m3, 0x00
    pshufd          m3, m3, 0x44

    pmullw          m0, m3, [multiL]            ; (x + 1) * topRight
    pmullw          m1, m3, [multiH]            ; (x + 1) * topRight
    pmullw          m2, m3, [multiH2]           ; (x + 1) * topRight
    pmullw          m3, [multiH3]               ; (x + 1) * topRight

    movd            m6, [r2 + 97]               ; bottomLeft = left[32]
    pand            m6, [pw_00ff]
    pshuflw         m6, m6, 0x00
    pshufd          m6, m6, 0x44
    mova            m5, m6
    paddw           m5, [pw_32]

    paddw           m0, m5
    paddw           m1, m5
    paddw           m2, m5
    paddw           m3, m5

    movh            m4, [r2 + 1]
    punpcklbw       m4, m7
    psubw           m5, m6, m4
    mova            [rsp + 0 * mmsize], m5
    pmullw          m4, [pw_planar32_1]
    paddw           m0, m4

    movh            m4, [r2 + 9]
    punpcklbw       m4, m7
    psubw           m5, m6, m4
    mova            [rsp + 1 * mmsize], m5
    pmullw          m4, [pw_planar32_1]
    paddw           m1, m4

    movh            m4, [r2 + 17]
    punpcklbw       m4, m7
    psubw           m5, m6, m4
    mova            [rsp + 2 * mmsize], m5
    pmullw          m4, [pw_planar32_1]
    paddw           m2, m4

    movh            m4, [r2 + 25]
    punpcklbw       m4, m7
    psubw           m5, m6, m4
    mova            [rsp + 3 * mmsize], m5
    pmullw          m4, [pw_planar32_1]
    paddw           m3, m4

%macro PROCESS 1
    pmullw          m5, %1, [pw_planar32_L]
    pmullw          m6, %1, [pw_planar32_H]
    paddw           m5, m0
    paddw           m6, m1
    psraw           m5, 6
    psraw           m6, 6
    packuswb        m5, m6
    movu            [r0], m5

    pmullw          m5, %1, [pw_planar16_0]
    pmullw          %1, [pw_planar8_0]
    paddw           m5, m2
    paddw           %1, m3
    psraw           m5, 6
    psraw           %1, 6
    packuswb        m5, %1
    movu            [r0 + 16], m5
%endmacro

%macro INCREMENT 0
    paddw           m0, [rsp + 0 * mmsize]
    paddw           m1, [rsp + 1 * mmsize]
    paddw           m2, [rsp + 2 * mmsize]
    paddw           m3, [rsp + 3 * mmsize]
    add             r0, r1
%endmacro

%assign y 0
%rep 4
    pxor            m7, m7
    movq            m4, [r2 + 65 + y * 8]
    punpcklbw       m4, m7
%assign x 0
%rep 8
    %if x < 4
    pshuflw         m7, m4, 0x55 * x
    pshufd          m7, m7, 0x44
    %else
    pshufhw         m7, m4, 0x55 * (x - 4)
    pshufd          m7, m7, 0xEE
    %endif

    PROCESS m7
    %if x + y < 10
    INCREMENT
    %endif
%assign x x+1
%endrep
%assign y y+1
%endrep
    RET

%endif ; end ARCH_X86_32

;---------------------------------------------------------------------------------------------
; void intra_pred_dc(pixel* dst, intptr_t dstStride, pixel *srcPix, int dirMode, int bFilter)
;---------------------------------------------------------------------------------------------
INIT_XMM sse4
cglobal intra_pred_dc4, 5,5,3
    inc         r2
    pxor        m0, m0
    movd        m1, [r2]
    movd        m2, [r2 + 8]
    punpckldq   m1, m2
    psadbw      m1, m0              ; m1 = sum

    test        r4d, r4d

    pmulhrsw    m1, [pw_4096]       ; m1 = (sum + 4) / 8
    movd        r4d, m1             ; r4d = dc_val
    pshufb      m1, m0              ; m1 = byte [dc_val ...]

    ; store DC 4x4
    lea         r3, [r1 * 3]
    movd        [r0], m1
    movd        [r0 + r1], m1
    movd        [r0 + r1 * 2], m1
    movd        [r0 + r3], m1

    ; do DC filter
    jz         .end
    lea         r3d, [r4d * 2 + 2]  ; r3d = DC * 2 + 2
    add         r4d, r3d            ; r4d = DC * 3 + 2
    movd        m1, r4d
    pshuflw     m1, m1, 0           ; m1 = pixDCx3
    pshufd      m1, m1, 0

    ; filter top
    movd        m2, [r2]
    movd        m0, [r2 + 9]
    punpckldq   m2, m0
    pmovzxbw    m2, m2
    paddw       m2, m1
    psraw       m2, 2
    packuswb    m2, m2
    movd        [r0], m2            ; overwrite top-left pixel, we will update it later

    ; filter top-left
    movzx       r4d, byte [r2 + 8]
    add         r3d, r4d
    movzx       r4d, byte [r2]
    add         r3d, r4d
    shr         r3d, 2
    mov         [r0], r3b

    ; filter left
    add         r0, r1
    pextrb      [r0], m2, 4
    pextrb      [r0 + r1], m2, 5
    pextrb      [r0 + r1 * 2], m2, 6

.end:
    RET

;---------------------------------------------------------------------------------------------
; void intra_pred_dc(pixel* dst, intptr_t dstStride, pixel *srcPix, int dirMode, int bFilter)
;---------------------------------------------------------------------------------------------
INIT_XMM sse4
cglobal intra_pred_dc8, 5, 7, 3
    lea             r3, [r2 + 17]
    inc             r2
    pxor            m0,            m0
    movh            m1,            [r2]
    movh            m2,            [r3]
    punpcklqdq      m1,            m2
    psadbw          m1,            m0
    pshufd          m2,            m1, 2
    paddw           m1,            m2

    movd            r5d,           m1
    add             r5d,           8
    shr             r5d,           4     ; sum = sum / 16
    movd            m1,            r5d
    pshufb          m1,            m0    ; m1 = byte [dc_val ...]

    test            r4d,           r4d

    ; store DC 8x8
    mov             r6,            r0
    movh            [r0],          m1
    movh            [r0 + r1],     m1
    lea             r0,            [r0 + r1 * 2]
    movh            [r0],          m1
    movh            [r0 + r1],     m1
    lea             r0,            [r0 + r1 * 2]
    movh            [r0],          m1
    movh            [r0 + r1],     m1
    lea             r0,            [r0 + r1 * 2]
    movh            [r0],          m1
    movh            [r0 + r1],     m1

    ; Do DC Filter
    jz              .end
    lea             r4d,           [r5d * 2 + 2]  ; r4d = DC * 2 + 2
    add             r5d,           r4d            ; r5d = DC * 3 + 2
    movd            m1,            r5d
    pshuflw         m1,            m1, 0          ; m1 = pixDCx3
    pshufd          m1,            m1, 0

    ; filter top
    pmovzxbw        m2,            [r2]
    paddw           m2,            m1
    psraw           m2,            2
    packuswb        m2,            m2
    movh            [r6],          m2

    ; filter top-left
    movzx           r5d, byte      [r3]
    add             r4d,           r5d
    movzx           r3d, byte      [r2]
    add             r3d,           r4d
    shr             r3d,           2
    mov             [r6],          r3b

    ; filter left
    add             r6,            r1
    pmovzxbw        m2,            [r2 + 17]
    paddw           m2,            m1
    psraw           m2,            2
    packuswb        m2,            m2
    pextrb          [r6],          m2, 0
    pextrb          [r6 + r1],     m2, 1
    pextrb          [r6 + 2 * r1], m2, 2
    lea             r6,            [r6 + r1 * 2]
    pextrb          [r6 + r1],     m2, 3
    pextrb          [r6 + r1 * 2], m2, 4
    pextrb          [r6 + r1 * 4], m2, 6
    lea             r1,            [r1 * 3]
    pextrb          [r6 + r1],     m2, 5

.end:
    RET

;--------------------------------------------------------------------------------------------
; void intra_pred_dc(pixel* dst, intptr_t dstStride, pixel *srcPix, int dirMode, int bFilter)
;--------------------------------------------------------------------------------------------
INIT_XMM sse4
cglobal intra_pred_dc16, 5, 7, 4
    lea             r3, [r2 + 33]
    inc             r2
    pxor            m0,            m0
    movu            m1,            [r2]
    movu            m2,            [r3]
    psadbw          m1,            m0
    psadbw          m2,            m0
    paddw           m1,            m2
    pshufd          m2,            m1, 2
    paddw           m1,            m2

    movd            r5d,           m1
    add             r5d,           16
    shr             r5d,           5     ; sum = sum / 32
    movd            m1,            r5d
    pshufb          m1,            m0    ; m1 = byte [dc_val ...]

    test            r4d,           r4d

    ; store DC 16x16
    mov             r6,            r0
    movu            [r0],          m1
    movu            [r0 + r1],     m1
    lea             r0,            [r0 + r1 * 2]
    movu            [r0],          m1
    movu            [r0 + r1],     m1
    lea             r0,            [r0 + r1 * 2]
    movu            [r0],          m1
    movu            [r0 + r1],     m1
    lea             r0,            [r0 + r1 * 2]
    movu            [r0],          m1
    movu            [r0 + r1],     m1
    lea             r0,            [r0 + r1 * 2]
    movu            [r0],          m1
    movu            [r0 + r1],     m1
    lea             r0,            [r0 + r1 * 2]
    movu            [r0],          m1
    movu            [r0 + r1],     m1
    lea             r0,            [r0 + r1 * 2]
    movu            [r0],          m1
    movu            [r0 + r1],     m1
    lea             r0,            [r0 + r1 * 2]
    movu            [r0],          m1
    movu            [r0 + r1],     m1

    ; Do DC Filter
    jz              .end
    lea             r4d,           [r5d * 2 + 2]  ; r4d = DC * 2 + 2
    add             r5d,           r4d            ; r5d = DC * 3 + 2
    movd            m1,            r5d
    pshuflw         m1,            m1, 0          ; m1 = pixDCx3
    pshufd          m1,            m1, 0

    ; filter top
    pmovzxbw        m2,            [r2]
    paddw           m2,            m1
    psraw           m2,            2
    packuswb        m2,            m2
    movh            [r6],          m2
    pmovzxbw        m3,            [r2 + 8]
    paddw           m3,            m1
    psraw           m3,            2
    packuswb        m3,            m3
    movh            [r6 + 8],      m3

    ; filter top-left
    movzx           r5d, byte      [r3]
    add             r4d,           r5d
    movzx           r3d, byte      [r2]
    add             r3d,           r4d
    shr             r3d,           2
    mov             [r6],          r3b

    ; filter left
    add             r6,            r1
    pmovzxbw        m2,            [r2 + 33]
    paddw           m2,            m1
    psraw           m2,            2
    packuswb        m2,            m2
    pextrb          [r6],          m2, 0
    pextrb          [r6 + r1],     m2, 1
    pextrb          [r6 + r1 * 2], m2, 2
    lea             r6,            [r6 + r1 * 2]
    pextrb          [r6 + r1],     m2, 3
    pextrb          [r6 + r1 * 2], m2, 4
    lea             r6,            [r6 + r1 * 2]
    pextrb          [r6 + r1],     m2, 5
    pextrb          [r6 + r1 * 2], m2, 6
    lea             r6,            [r6 + r1 * 2]
    pextrb          [r6 + r1],     m2, 7

    pmovzxbw        m3,            [r2 + 41]
    paddw           m3,            m1
    psraw           m3,            2
    packuswb        m3,            m3
    pextrb          [r6 + r1 * 2], m3, 0
    lea             r6,            [r6 + r1 * 2]
    pextrb          [r6 + r1],     m3, 1
    pextrb          [r6 + r1 * 2], m3, 2
    lea             r6,            [r6 + r1 * 2]
    pextrb          [r6 + r1],     m3, 3
    pextrb          [r6 + r1 * 2], m3, 4
    lea             r6,            [r6 + r1 * 2]
    pextrb          [r6 + r1],     m3, 5
    pextrb          [r6 + r1 * 2], m3, 6

.end:
    RET

;---------------------------------------------------------------------------------------------
; void intra_pred_dc(pixel* dst, intptr_t dstStride, pixel *srcPix, int dirMode, int bFilter)
;---------------------------------------------------------------------------------------------
INIT_XMM sse4
cglobal intra_pred_dc32, 3, 5, 5
    lea             r3, [r2 + 65]
    inc             r2
    pxor            m0,            m0
    movu            m1,            [r2]
    movu            m2,            [r2 + 16]
    movu            m3,            [r3]
    movu            m4,            [r3 + 16]
    psadbw          m1,            m0
    psadbw          m2,            m0
    psadbw          m3,            m0
    psadbw          m4,            m0
    paddw           m1,            m2
    paddw           m3,            m4
    paddw           m1,            m3
    pshufd          m2,            m1, 2
    paddw           m1,            m2

    movd            r4d,           m1
    add             r4d,           32
    shr             r4d,           6     ; sum = sum / 64
    movd            m1,            r4d
    pshufb          m1,            m0    ; m1 = byte [dc_val ...]

%rep 2
    ; store DC 16x16
    movu            [r0],          m1
    movu            [r0 + r1],     m1
    movu            [r0 + 16],     m1
    movu            [r0 + r1 + 16],m1
    lea             r0,            [r0 + 2 * r1]
    movu            [r0],          m1
    movu            [r0 + r1],     m1
    movu            [r0 + 16],     m1
    movu            [r0 + r1 + 16],m1
    lea             r0,            [r0 + 2 * r1]
    movu            [r0],          m1
    movu            [r0 + r1],     m1
    movu            [r0 + 16],     m1
    movu            [r0 + r1 + 16],m1
    lea             r0,            [r0 + 2 * r1]
    movu            [r0],          m1
    movu            [r0 + r1],     m1
    movu            [r0 + 16],     m1
    movu            [r0 + r1 + 16],m1
    lea             r0,            [r0 + 2 * r1]
    movu            [r0],          m1
    movu            [r0 + r1],     m1
    movu            [r0 + 16],     m1
    movu            [r0 + r1 + 16],m1
    lea             r0,            [r0 + 2 * r1]
    movu            [r0],          m1
    movu            [r0 + r1],     m1
    movu            [r0 + 16],     m1
    movu            [r0 + r1 + 16],m1
    lea             r0,            [r0 + 2 * r1]
    movu            [r0],          m1
    movu            [r0 + r1],     m1
    movu            [r0 + 16],     m1
    movu            [r0 + r1 + 16],m1
    lea             r0,            [r0 + 2 * r1]
    movu            [r0],          m1
    movu            [r0 + r1],     m1
    movu            [r0 + 16],     m1
    movu            [r0 + r1 + 16],m1
    lea             r0,            [r0 + 2 * r1]
%endrep

    RET

;---------------------------------------------------------------------------------------
; void intra_pred_planar(pixel* dst, intptr_t dstStride, pixel*srcPix, int, int filter)
;---------------------------------------------------------------------------------------
INIT_XMM sse4
cglobal intra_pred_planar4, 3,3,7
    pmovzxbw        m1, [r2 + 1]
    pmovzxbw        m2, [r2 + 9]
    pshufhw         m3, m1, 0               ; topRight
    pshufd          m3, m3, 0xAA
    pshufhw         m4, m2, 0               ; bottomLeft
    pshufd          m4, m4, 0xAA

    pmullw          m3, [multi_2Row]        ; (x + 1) * topRight
    pmullw          m0, m1, [pw_planar4_1]  ; (blkSize - 1 - y) * above[x]
    mova            m6, [pw_planar4_0]
    paddw           m3, [pw_4]
    paddw           m3, m4
    paddw           m3, m0
    psubw           m4, m1

    pshuflw         m5, m2, 0
    pmullw          m5, m6
    paddw           m5, m3
    paddw           m3, m4
    psraw           m5, 3
    packuswb        m5, m5
    movd            [r0], m5

    pshuflw         m5, m2, 01010101b
    pmullw          m5, m6
    paddw           m5, m3
    paddw           m3, m4
    psraw           m5, 3
    packuswb        m5, m5
    movd            [r0 + r1], m5
    lea             r0, [r0 + 2 * r1]

    pshuflw         m5, m2, 10101010b
    pmullw          m5, m6
    paddw           m5, m3
    paddw           m3, m4
    psraw           m5, 3
    packuswb        m5, m5
    movd            [r0], m5

    pshuflw         m5, m2, 11111111b
    pmullw          m5, m6
    paddw           m5, m3
    paddw           m3, m4
    psraw           m5, 3
    packuswb        m5, m5
    movd            [r0 + r1], m5
    RET

;---------------------------------------------------------------------------------------
; void intra_pred_planar(pixel* dst, intptr_t dstStride, pixel*srcPix, int, int filter)
;---------------------------------------------------------------------------------------
INIT_XMM sse4
cglobal intra_pred_planar8, 3,3,7
    pmovzxbw        m1, [r2 + 1]
    pmovzxbw        m2, [r2 + 17]

    movd            m3, [r2 + 9]            ; topRight   = above[8];
    movd            m4, [r2 + 25]           ; bottomLeft = left[8];

    pxor            m0, m0
    pshufb          m3, m0
    pshufb          m4, m0
    punpcklbw       m3, m0                  ; v_topRight
    punpcklbw       m4, m0                  ; v_bottomLeft

    pmullw          m3, [multiL]            ; (x + 1) * topRight
    pmullw          m0, m1, [pw_planar8_1]  ; (blkSize - 1 - y) * above[x]
    mova            m6, [pw_planar8_0]
    paddw           m3, [pw_8]
    paddw           m3, m4
    paddw           m3, m0
    psubw           m4, m1

%macro INTRA_PRED_PLANAR8 1
%if (%1 < 4)
    pshuflw         m5, m2, 0x55 * %1
    pshufd          m5, m5, 0
%else
    pshufhw         m5, m2, 0x55 * (%1 - 4)
    pshufd          m5, m5, 0xAA
%endif
    pmullw          m5, m6
    paddw           m5, m3
    paddw           m3, m4
    psraw           m5, 4
    packuswb        m5, m5
    movh            [r0], m5
    lea             r0, [r0 + r1]
%endmacro

    INTRA_PRED_PLANAR8 0
    INTRA_PRED_PLANAR8 1
    INTRA_PRED_PLANAR8 2
    INTRA_PRED_PLANAR8 3
    INTRA_PRED_PLANAR8 4
    INTRA_PRED_PLANAR8 5
    INTRA_PRED_PLANAR8 6
    INTRA_PRED_PLANAR8 7
    RET

;---------------------------------------------------------------------------------------
; void intra_pred_planar(pixel* dst, intptr_t dstStride, pixel*srcPix, int, int filter)
;---------------------------------------------------------------------------------------
INIT_XMM sse4
cglobal intra_pred_planar16, 3,3,8
    pmovzxbw        m2, [r2 + 1]
    pmovzxbw        m7, [r2 + 9]

    movd            m3, [r2 + 17]               ; topRight   = above[16]
    movd            m6, [r2 + 49]               ; bottomLeft = left[16]

    pxor            m0, m0
    pshufb          m3, m0
    pshufb          m6, m0
    punpcklbw       m3, m0                      ; v_topRight
    punpcklbw       m6, m0                      ; v_bottomLeft

    pmullw          m4, m3, [multiH]            ; (x + 1) * topRight
    pmullw          m3, [multiL]                ; (x + 1) * topRight
    pmullw          m1, m2, [pw_planar16_1]     ; (blkSize - 1 - y) * above[x]
    pmullw          m5, m7, [pw_planar16_1]     ; (blkSize - 1 - y) * above[x]
    paddw           m4, [pw_16]
    paddw           m3, [pw_16]
    paddw           m4, m6
    paddw           m3, m6
    paddw           m4, m5
    paddw           m3, m1
    psubw           m1, m6, m7
    psubw           m6, m2

    pmovzxbw        m2, [r2 + 33]
    pmovzxbw        m7, [r2 + 41]

%macro INTRA_PRED_PLANAR16 1
%if (%1 < 4)
    pshuflw         m5, m2, 0x55 * %1
    pshufd          m5, m5, 0
%else
%if (%1 < 8)
    pshufhw         m5, m2, 0x55 * (%1 - 4)
    pshufd          m5, m5, 0xAA
%else
%if (%1 < 12)
    pshuflw         m5, m7, 0x55 * (%1 - 8)
    pshufd          m5, m5, 0
%else
    pshufhw         m5, m7, 0x55 * (%1 - 12)
    pshufd          m5, m5, 0xAA
%endif
%endif
%endif
    pmullw          m0, m5, [pw_planar8_0]
    pmullw          m5, [pw_planar16_0]
    paddw           m0, m4
    paddw           m5, m3
    paddw           m3, m6
    paddw           m4, m1
    psraw           m5, 5
    psraw           m0, 5
    packuswb        m5, m0
    movu            [r0], m5
    lea             r0, [r0 + r1]
%endmacro

    INTRA_PRED_PLANAR16 0
    INTRA_PRED_PLANAR16 1
    INTRA_PRED_PLANAR16 2
    INTRA_PRED_PLANAR16 3
    INTRA_PRED_PLANAR16 4
    INTRA_PRED_PLANAR16 5
    INTRA_PRED_PLANAR16 6
    INTRA_PRED_PLANAR16 7
    INTRA_PRED_PLANAR16 8
    INTRA_PRED_PLANAR16 9
    INTRA_PRED_PLANAR16 10
    INTRA_PRED_PLANAR16 11
    INTRA_PRED_PLANAR16 12
    INTRA_PRED_PLANAR16 13
    INTRA_PRED_PLANAR16 14
    INTRA_PRED_PLANAR16 15
    RET

;---------------------------------------------------------------------------------------
; void intra_pred_planar(pixel* dst, intptr_t dstStride, pixel*srcPix, int, int filter)
;---------------------------------------------------------------------------------------
INIT_XMM sse4
%if ARCH_X86_64 == 1
cglobal intra_pred_planar32, 3,4,12
%else
cglobal intra_pred_planar32, 3,4,8,0-(4*mmsize)
  %define           m8  [rsp + 0 * mmsize]
  %define           m9  [rsp + 1 * mmsize]
  %define           m10 [rsp + 2 * mmsize]
  %define           m11 [rsp + 3 * mmsize]
%endif
    movd            m3, [r2 + 33]               ; topRight   = above[32]

    pxor            m7, m7
    pshufb          m3, m7
    punpcklbw       m3, m7                      ; v_topRight

    pmullw          m0, m3, [multiL]            ; (x + 1) * topRight
    pmullw          m1, m3, [multiH]            ; (x + 1) * topRight
    pmullw          m2, m3, [multiH2]           ; (x + 1) * topRight
    pmullw          m3, [multiH3]               ; (x + 1) * topRight

    movd            m6, [r2 + 97]               ; bottomLeft = left[32]
    pshufb          m6, m7
    punpcklbw       m6, m7                      ; v_bottomLeft

    paddw           m0, m6
    paddw           m1, m6
    paddw           m2, m6
    paddw           m3, m6
    paddw           m0, [pw_32]
    paddw           m1, [pw_32]
    paddw           m2, [pw_32]
    paddw           m3, [pw_32]

    pmovzxbw        m4, [r2 + 1]
    pmullw          m5, m4, [pw_planar32_1]
    paddw           m0, m5
    psubw           m5, m6, m4
    mova            m8, m5

    pmovzxbw        m4, [r2 + 9]
    pmullw          m5, m4, [pw_planar32_1]
    paddw           m1, m5
    psubw           m5, m6, m4
    mova            m9, m5

    pmovzxbw        m4, [r2 + 17]
    pmullw          m5, m4, [pw_planar32_1]
    paddw           m2, m5
    psubw           m5, m6, m4
    mova            m10, m5

    pmovzxbw        m4, [r2 + 25]
    pmullw          m5, m4, [pw_planar32_1]
    paddw           m3, m5
    psubw           m5, m6, m4
    mova            m11, m5
    add             r2, 65                      ; (2 * blkSize + 1)

%macro INTRA_PRED_PLANAR32 0
    movd            m4, [r2]
    pshufb          m4, m7
    punpcklbw       m4, m7

    pmullw          m5, m4, [pw_planar32_L]
    pmullw          m6, m4, [pw_planar32_H]
    paddw           m5, m0
    paddw           m6, m1
    paddw           m0, m8
    paddw           m1, m9
    psraw           m5, 6
    psraw           m6, 6
    packuswb        m5, m6
    movu            [r0], m5

    pmullw          m5, m4, [pw_planar16_0]
    pmullw          m4, [pw_planar8_0]
    paddw           m5, m2
    paddw           m4, m3
    paddw           m2, m10
    paddw           m3, m11
    psraw           m5, 6
    psraw           m4, 6
    packuswb        m5, m4
    movu            [r0 + 16], m5

    lea             r0, [r0 + r1]
    inc             r2
%endmacro

    mov             r3, 4
.loop:
    INTRA_PRED_PLANAR32
    INTRA_PRED_PLANAR32
    INTRA_PRED_PLANAR32
    INTRA_PRED_PLANAR32
    INTRA_PRED_PLANAR32
    INTRA_PRED_PLANAR32
    INTRA_PRED_PLANAR32
    INTRA_PRED_PLANAR32
    dec             r3
    jnz             .loop
    RET

;-----------------------------------------------------------------------------------------
; void intraPredAng4(pixel* dst, intptr_t dstStride, pixel* src, int dirMode, int bFilter)
;-----------------------------------------------------------------------------------------
INIT_XMM ssse3
cglobal intra_pred_ang4_2, 3,5,3
    lea         r4, [r2 + 2]
    add         r2, 10
    cmp         r3m, byte 34
    cmove       r2, r4

    movh        m0, [r2]
    movd        [r0], m0
    palignr     m1, m0, 1
    movd        [r0 + r1], m1
    palignr     m2, m0, 2
    movd        [r0 + r1 * 2], m2
    lea         r1, [r1 * 3]
    psrldq      m0, 3
    movd        [r0 + r1], m0
    RET

INIT_XMM sse4
cglobal intra_pred_ang4_3, 3,5,5
    mov         r4, 1
    cmp         r3m, byte 33
    mov         r3, 9
    cmove       r3, r4

    movh        m0, [r2 + r3]   ; [8 7 6 5 4 3 2 1]
    palignr     m1, m0, 1       ; [x 8 7 6 5 4 3 2]
    punpcklbw   m0, m1          ; [x 8 8 7 7 6 6 5 5 4 4 3 3 2 2 1]
    palignr     m1, m0, 2       ; [x x x x x x x x 6 5 5 4 4 3 3 2]
    palignr     m2, m0, 4       ; [x x x x x x x x 7 6 6 5 5 4 4 3]
    palignr     m3, m0, 6       ; [x x x x x x x x 8 7 7 6 6 5 5 4]
    punpcklqdq  m0, m1
    punpcklqdq  m2, m3

    lea         r3, [ang_table + 20 * 16]
    movh        m3, [r3 + 6 * 16]   ; [26]
    movhps      m3, [r3]            ; [20]
    movh        m4, [r3 - 6 * 16]   ; [14]
    movhps      m4, [r3 - 12 * 16]  ; [ 8]
    jmp        .do_filter4x4

    ; NOTE: share path, input is m0=[1 0], m2=[3 2], m3,m4=coef, flag_z=no_transpose
ALIGN 16
.do_filter4x4:
    mova        m1, [pw_1024]

    pmaddubsw   m0, m3
    pmulhrsw    m0, m1
    pmaddubsw   m2, m4
    pmulhrsw    m2, m1
    packuswb    m0, m2

    ; NOTE: mode 33 doesn't reorde, UNSAFE but I don't use any instruction that affect eflag register before
    jz         .store

    ; transpose 4x4
    pshufb      m0, [c_trans_4x4]

.store:
    ; TODO: use pextrd here after intrinsic ssse3 removed
    movd        [r0], m0
    pextrd      [r0 + r1], m0, 1
    pextrd      [r0 + r1 * 2], m0, 2
    lea         r1, [r1 * 3]
    pextrd      [r0 + r1], m0, 3
    RET

cglobal intra_pred_ang4_4, 3,5,5
    xor         r4, r4
    inc         r4
    cmp         r3m, byte 32
    mov         r3, 9
    cmove       r3, r4

    movh        m0, [r2 + r3]    ; [8 7 6 5 4 3 2 1]
    palignr     m1, m0, 1       ; [x 8 7 6 5 4 3 2]
    punpcklbw   m0, m1          ; [x 8 8 7 7 6 6 5 5 4 4 3 3 2 2 1]
    palignr     m1, m0, 2       ; [x x x x x x x x 6 5 5 4 4 3 3 2]
    palignr     m3, m0, 4       ; [x x x x x x x x 7 6 6 5 5 4 4 3]
    punpcklqdq  m0, m1
    punpcklqdq  m2, m1, m3

    lea         r3, [ang_table + 18 * 16]
    movh        m3, [r3 +  3 * 16]  ; [21]
    movhps      m3, [r3 -  8 * 16]  ; [10]
    movh        m4, [r3 + 13 * 16]  ; [31]
    movhps      m4, [r3 +  2 * 16]  ; [20]
    jmp         mangle(private_prefix %+ _ %+ intra_pred_ang4_3 %+ SUFFIX %+ .do_filter4x4)

cglobal intra_pred_ang4_5, 3,5,5
    xor         r4, r4
    inc         r4
    cmp         r3m, byte 31
    mov         r3, 9
    cmove       r3, r4

    movh        m0, [r2 + r3]    ; [8 7 6 5 4 3 2 1]
    palignr     m1, m0, 1       ; [x 8 7 6 5 4 3 2]
    punpcklbw   m0, m1          ; [x 8 8 7 7 6 6 5 5 4 4 3 3 2 2 1]
    palignr     m1, m0, 2       ; [x x x x x x x x 6 5 5 4 4 3 3 2]
    palignr     m3, m0, 4       ; [x x x x x x x x 7 6 6 5 5 4 4 3]
    punpcklqdq  m0, m1
    punpcklqdq  m2, m1, m3

    lea         r3, [ang_table + 10 * 16]
    movh        m3, [r3 +  7 * 16]  ; [17]
    movhps      m3, [r3 -  8 * 16]  ; [ 2]
    movh        m4, [r3 +  9 * 16]  ; [19]
    movhps      m4, [r3 -  6 * 16]  ; [ 4]
    jmp         mangle(private_prefix %+ _ %+ intra_pred_ang4_3 %+ SUFFIX %+ .do_filter4x4)

cglobal intra_pred_ang4_6, 3,5,5
    xor         r4, r4
    inc         r4
    cmp         r3m, byte 30
    mov         r3, 9
    cmove       r3, r4

    movh        m0, [r2 + r3]    ; [8 7 6 5 4 3 2 1]
    palignr     m1, m0, 1       ; [x 8 7 6 5 4 3 2]
    punpcklbw   m0, m1          ; [x 8 8 7 7 6 6 5 5 4 4 3 3 2 2 1]
    palignr     m2, m0, 2       ; [x x x x x x x x 6 5 5 4 4 3 3 2]
    punpcklqdq  m0, m0
    punpcklqdq  m2, m2

    lea         r3, [ang_table + 19 * 16]
    movh        m3, [r3 -  6 * 16]  ; [13]
    movhps      m3, [r3 +  7 * 16]  ; [26]
    movh        m4, [r3 - 12 * 16]  ; [ 7]
    movhps      m4, [r3 +  1 * 16]  ; [20]
    jmp         mangle(private_prefix %+ _ %+ intra_pred_ang4_3 %+ SUFFIX %+ .do_filter4x4)

cglobal intra_pred_ang4_7, 3,5,5
    xor         r4, r4
    inc         r4
    cmp         r3m, byte 29
    mov         r3, 9
    cmove       r3, r4

    movh        m0, [r2 + r3]    ; [8 7 6 5 4 3 2 1]
    palignr     m1, m0, 1       ; [x 8 7 6 5 4 3 2]
    punpcklbw   m0, m1          ; [x 8 8 7 7 6 6 5 5 4 4 3 3 2 2 1]
    palignr     m3, m0, 2       ; [x x x x x x x x 6 5 5 4 4 3 3 2]
    punpcklqdq  m2, m0, m3
    punpcklqdq  m0, m0

    lea         r3, [ang_table + 20 * 16]
    movh        m3, [r3 - 11 * 16]  ; [ 9]
    movhps      m3, [r3 -  2 * 16]  ; [18]
    movh        m4, [r3 +  7 * 16]  ; [27]
    movhps      m4, [r3 - 16 * 16]  ; [ 4]
    jmp         mangle(private_prefix %+ _ %+ intra_pred_ang4_3 %+ SUFFIX %+ .do_filter4x4)

cglobal intra_pred_ang4_8, 3,5,5
    xor         r4, r4
    inc         r4
    cmp         r3m, byte 28
    mov         r3, 9
    cmove       r3, r4

    movh        m0, [r2 + r3]    ; [8 7 6 5 4 3 2 1]
    palignr     m1, m0, 1       ; [x 8 7 6 5 4 3 2]
    punpcklbw   m0, m1          ; [x 8 8 7 7 6 6 5 5 4 4 3 3 2 2 1]
    punpcklqdq  m0, m0
    mova        m2, m0

    lea         r3, [ang_table + 13 * 16]
    movh        m3, [r3 -  8 * 16]  ; [ 5]
    movhps      m3, [r3 -  3 * 16]  ; [10]
    movh        m4, [r3 +  2 * 16]  ; [15]
    movhps      m4, [r3 +  7 * 16]  ; [20]
    jmp         mangle(private_prefix %+ _ %+ intra_pred_ang4_3 %+ SUFFIX %+ .do_filter4x4)

cglobal intra_pred_ang4_9, 3,5,5
    xor         r4, r4
    inc         r4
    cmp         r3m, byte 27
    mov         r3, 9
    cmove       r3, r4

    movh        m0, [r2 + r3]    ; [8 7 6 5 4 3 2 1]
    palignr     m1, m0, 1       ; [x 8 7 6 5 4 3 2]
    punpcklbw   m0, m1          ; [x 8 8 7 7 6 6 5 5 4 4 3 3 2 2 1]
    punpcklqdq  m0, m0
    mova        m2, m0

    lea         r3, [ang_table + 4 * 16]
    movh        m3, [r3 -  2 * 16]  ; [ 2]
    movhps      m3, [r3 -  0 * 16]  ; [ 4]
    movh        m4, [r3 +  2 * 16]  ; [ 6]
    movhps      m4, [r3 +  4 * 16]  ; [ 8]
    jmp         mangle(private_prefix %+ _ %+ intra_pred_ang4_3 %+ SUFFIX %+ .do_filter4x4)

cglobal intra_pred_ang4_10, 3,3,4
    movd        m0, [r2 + 9]            ; [8 7 6 5 4 3 2 1]
    pshufb      m0, [pb_unpackbd1]
    pshufd      m1, m0, 1
    movhlps     m2, m0
    pshufd      m3, m0, 3
    movd        [r0 + r1], m1
    movd        [r0 + r1 * 2], m2
    lea         r1, [r1 * 3]
    movd        [r0 + r1], m3
    cmp         r4m, byte 0
    jz          .quit

    ; filter
    pmovzxbw    m0, m0                  ; [-1 -1 -1 -1]
    movh        m1, [r2]                ; [4 3 2 1 0]
    pshufb      m2, m1, [pb_0_8]        ; [0 0 0 0]
    pshufb      m1, [pb_unpackbw1]      ; [4 3 2 1]
    psubw       m1, m2
    psraw       m1, 1
    paddw       m0, m1
    packuswb    m0, m0
.quit:
    movd        [r0], m0
    RET

INIT_XMM sse4
cglobal intra_pred_ang4_26, 3,4,3
    movd        m0, [r2 + 1]            ; [8 7 6 5 4 3 2 1]

    ; store
    movd        [r0], m0
    movd        [r0 + r1], m0
    movd        [r0 + r1 * 2], m0
    lea         r3, [r1 * 3]
    movd        [r0 + r3], m0

    ; filter
    cmp         r4m, byte 0
    jz         .quit

    pshufb      m0, [pb_0_8]            ; [ 1  1  1  1]
    movh        m1, [r2 + 8]                ; [-4 -3 -2 -1 0]
    pinsrb      m1, [r2], 0
    pshufb      m2, m1, [pb_0_8]        ; [0 0 0 0]
    pshufb      m1, [pb_unpackbw1]      ; [-4 -3 -2 -1]
    psubw       m1, m2
    psraw       m1, 1
    paddw       m0, m1
    packuswb    m0, m0

    pextrb      [r0], m0, 0
    pextrb      [r0 + r1], m0, 1
    pextrb      [r0 + r1 * 2], m0, 2
    pextrb      [r0 + r3], m0, 3
.quit:
    RET

cglobal intra_pred_ang4_11, 3,5,5
    xor         r4, r4
    cmp         r3m, byte 25
    mov         r3, 8
    cmove       r3, r4

    movh        m0, [r2 + r3]        ; [x x x 4 3 2 1 0]
    pinsrb      m0, [r2], 0
    palignr     m1, m0, 1       ; [x x x x 4 3 2 1]
    punpcklbw   m0, m1          ; [x x x x x x x x 4 3 3 2 2 1 1 0]
    punpcklqdq  m0, m0
    mova        m2, m0

    lea         r3, [ang_table + 24 * 16]

    movh        m3, [r3 +  6 * 16]  ; [24]
    movhps      m3, [r3 +  4 * 16]  ; [26]
    movh        m4, [r3 +  2 * 16]  ; [28]
    movhps      m4, [r3 +  0 * 16]  ; [30]
    jmp         mangle(private_prefix %+ _ %+ intra_pred_ang4_3 %+ SUFFIX %+ .do_filter4x4)

cglobal intra_pred_ang4_12, 3,5,5
    xor         r4, r4
    cmp         r3m, byte 24
    mov         r3, 8
    cmove       r3, r4

    movh        m0, [r2 + r3]        ; [x x x 4 3 2 1 0]
    pinsrb      m0, [r2], 0
    palignr     m1, m0, 1       ; [x x x x 4 3 2 1]
    punpcklbw   m0, m1          ; [x x x x x x x x 4 3 3 2 2 1 1 0]
    punpcklqdq  m0, m0
    mova        m2, m0

    lea         r3, [ang_table + 20 * 16]
    movh        m3, [r3 +  7 * 16]  ; [27]
    movhps      m3, [r3 +  2 * 16]  ; [22]
    movh        m4, [r3 -  3 * 16]  ; [17]
    movhps      m4, [r3 -  8 * 16]  ; [12]
    jmp         mangle(private_prefix %+ _ %+ intra_pred_ang4_3 %+ SUFFIX %+ .do_filter4x4)

cglobal intra_pred_ang4_13, 4,5,5
    xor         r4, r4
    cmp         r3m, byte 23
    mov         r3, 8
    jz          .next
    xchg        r3, r4
.next:
    movh        m1, [r2 + r4 - 1]    ; [x x 4 3 2 1 0 x]
    pinsrb      m1, [r2], 1
    palignr     m0, m1, 1       ; [x x x 4 3 2 1 0]
    palignr     m2, m1, 2       ; [x x x x 4 3 2 1]
    pinsrb      m1, [r2 + r3 + 4], 0
    punpcklbw   m1, m0          ; [3 2 2 1 1 0 0 x]
    punpcklbw   m0, m2          ; [4 3 3 2 2 1 1 0]
    punpcklqdq  m2, m0, m1
    punpcklqdq  m0, m0

    lea         r3, [ang_table + 21 * 16]
    movh        m3, [r3 +  2 * 16]  ; [23]
    movhps      m3, [r3 -  7 * 16]  ; [14]
    movh        m4, [r3 - 16 * 16]  ; [ 5]
    movhps      m4, [r3 +  7 * 16]  ; [28]
    jmp         mangle(private_prefix %+ _ %+ intra_pred_ang4_3 %+ SUFFIX %+ .do_filter4x4)

cglobal intra_pred_ang4_14, 4,5,5
    xor         r4, r4
    cmp         r3m, byte 22
    mov         r3, 8
    jz          .next
    xchg        r3, r4
.next:
    movh        m2, [r2 + r4 - 1]    ; [x x 4 3 2 1 0 x]
    pinsrb      m2, [r2], 1
    palignr     m0, m2, 1       ; [x x x 4 3 2 1 0]
    palignr     m1, m2, 2       ; [x x x x 4 3 2 1]
    pinsrb      m2, [r2 + r3 + 2], 0
    punpcklbw   m2, m0          ; [3 2 2 1 1 0 0 x]
    punpcklbw   m0, m1          ; [4 3 3 2 2 1 1 0]
    punpcklqdq  m0, m0
    punpcklqdq  m2, m2

    lea         r3, [ang_table + 19 * 16]
    movh        m3, [r3 +  0 * 16]  ; [19]
    movhps      m3, [r3 - 13 * 16]  ; [ 6]
    movh        m4, [r3 +  6 * 16]  ; [25]
    movhps      m4, [r3 -  7 * 16]  ; [12]
    jmp         mangle(private_prefix %+ _ %+ intra_pred_ang4_3 %+ SUFFIX %+ .do_filter4x4)

cglobal intra_pred_ang4_15, 4,5,5
    xor         r4, r4
    cmp         r3m, byte 21
    mov         r3, 8
    jz          .next
    xchg        r3, r4
.next:
    movh        m2, [r2 + r4 - 1]    ; [x x 4 3 2 1 0 x]
    pinsrb      m2, [r2], 1
    palignr     m0, m2, 1       ; [x x x 4 3 2 1 0]
    palignr     m1, m2, 2       ; [x x x x 4 3 2 1]
    pinsrb      m2, [r2 + r3 + 2], 0
    pslldq      m3, m2, 1       ; [x 4 3 2 1 0 x y]
    pinsrb      m3, [r2 + r3 + 4], 0
    punpcklbw   m4, m3, m2      ; [2 1 1 0 0 x x y]
    punpcklbw   m2, m0          ; [3 2 2 1 1 0 0 x]
    punpcklbw   m0, m1          ; [4 3 3 2 2 1 1 0]
    punpcklqdq  m0, m2
    punpcklqdq  m2, m4

    lea         r3, [ang_table + 23 * 16]
    movh        m3, [r3 -  8 * 16]  ; [15]
    movhps      m3, [r3 +  7 * 16]  ; [30]
    movh        m4, [r3 - 10 * 16]  ; [13]
    movhps      m4, [r3 +  5 * 16]  ; [28]
    jmp         mangle(private_prefix %+ _ %+ intra_pred_ang4_3 %+ SUFFIX %+ .do_filter4x4)

cglobal intra_pred_ang4_16, 3,5,5
    xor         r4, r4
    cmp         r3m, byte 20
    mov         r3, 8
    jz          .next
    xchg        r3, r4
.next:
    movh        m2, [r2 + r4 - 1]    ; [x x 4 3 2 1 0 x]
    pinsrb      m2, [r2], 1
    palignr     m0, m2, 1       ; [x x x 4 3 2 1 0]
    palignr     m1, m2, 2       ; [x x x x 4 3 2 1]
    pinsrb      m2, [r2 + r3 + 2], 0
    pslldq      m3, m2, 1       ; [x 4 3 2 1 0 x y]
    pinsrb      m3, [r2 + r3 + 3], 0
    punpcklbw   m4, m3, m2      ; [2 1 1 0 0 x x y]
    punpcklbw   m2, m0          ; [3 2 2 1 1 0 0 x]
    punpcklbw   m0, m1          ; [4 3 3 2 2 1 1 0]
    punpcklqdq  m0, m2
    punpcklqdq  m2, m4

    lea         r3, [ang_table + 19 * 16]
    movh        m3, [r3 -  8 * 16]  ; [11]
    movhps      m3, [r3 +  3 * 16]  ; [22]
    movh        m4, [r3 - 18 * 16]  ; [ 1]
    movhps      m4, [r3 -  7 * 16]  ; [12]
    jmp         mangle(private_prefix %+ _ %+ intra_pred_ang4_3 %+ SUFFIX %+ .do_filter4x4)

cglobal intra_pred_ang4_17, 3,5,5
    xor         r4, r4
    cmp         r3m, byte 19
    mov         r3, 8
    jz          .next
    xchg        r3, r4
.next:
    movh        m3, [r2 + r4 - 1]    ; [- - 4 3 2 1 0 x]
    pinsrb      m3, [r2], 1
    palignr     m0, m3, 1       ; [- - - 4 3 2 1 0]
    palignr     m1, m3, 2       ; [- - - - 4 3 2 1]
    mova        m4, m0
    punpcklbw   m0, m1          ; [4 3 3 2 2 1 1 0]
    pinsrb      m3, [r2 + r3 + 1], 0
    punpcklbw   m1, m3, m4      ; [3 2 2 1 1 0 0 x]
    punpcklqdq  m0, m1

    pslldq      m2, m3, 1       ; [- 4 3 2 1 0 x y]
    pinsrb      m2, [r2 + r3 + 2], 0
    pslldq      m1, m2, 1       ; [4 3 2 1 0 x y z]
    pinsrb      m1, [r2 + r3 + 4], 0
    punpcklbw   m1, m2          ; [1 0 0 x x y y z]
    punpcklbw   m2, m3          ; [2 1 1 0 0 x x y]
    punpcklqdq  m2, m1

    lea         r3, [ang_table + 14 * 16]
    movh        m3, [r3 -  8 * 16]  ; [ 6]
    movhps      m3, [r3 -  2 * 16]  ; [12]
    movh        m4, [r3 +  4 * 16]  ; [18]
    movhps      m4, [r3 + 10 * 16]  ; [24]
    jmp         mangle(private_prefix %+ _ %+ intra_pred_ang4_3 %+ SUFFIX %+ .do_filter4x4)

cglobal intra_pred_ang4_18, 3,5,1
    mov         r4d, [r2 + 8]
    mov         r3b, byte [r2]
    mov         [r2 + 8], r3b
    mov         r3d, [r2 + 8]
    bswap       r3d
    movd        m0, r3d

    pinsrd      m0, [r2 + 1], 1     ; [- 3 2 1 0 -1 -2 -3]
    lea         r3, [r1 * 3]
    movd        [r0 + r3], m0
    psrldq      m0, 1
    movd        [r0 + r1 * 2], m0
    psrldq      m0, 1
    movd        [r0 + r1], m0
    psrldq      m0, 1
    movd        [r0], m0
    mov         [r2 + 8], r4w
    RET

;-----------------------------------------------------------------------------------------
; void intraPredAng8(pixel* dst, intptr_t dstStride, pixel* src, int dirMode, int bFilter)
;-----------------------------------------------------------------------------------------
INIT_XMM ssse3
cglobal intra_pred_ang8_2, 3,5,2
    lea         r4,             [r2 + 2]
    add         r2,             18
    cmp         r3m,            byte 34
    cmove       r2,             r4
    movu        m0,             [r2]
    lea         r4,             [r1 * 3]

    movh        [r0],           m0
    palignr     m1,             m0, 1
    movh        [r0 + r1],      m1
    palignr     m1,             m0, 2
    movh        [r0 + r1 * 2],  m1
    palignr     m1,             m0, 3
    movh        [r0 + r4],      m1
    palignr     m1,             m0, 4
    lea         r0,             [r0 + r1 * 4]
    movh        [r0],           m1
    palignr     m1,             m0, 5
    movh        [r0 + r1],      m1
    palignr     m1,             m0, 6
    movh        [r0 + r1 * 2],  m1
    palignr     m1,             m0, 7
    movh        [r0 + r4],      m1
    RET

INIT_XMM sse4
cglobal intra_pred_ang8_3, 3,5,8
    lea         r4,        [r2 + 1]
    add         r2,        17
    cmp         r3m,       byte 33
    cmove       r2,        r4
    lea         r3,        [ang_table + 22 * 16]
    lea         r4,        [ang_table +  8 * 16]
    mova        m3,        [pw_1024]

    movu        m0,        [r2]                       ; [16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1]
    palignr     m1,        m0, 1                      ; [x 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2]

    punpckhbw   m2,        m0, m1                     ; [x 16 16 15 15 14 14 13 13 12 12 11 11 10 10 9]
    punpcklbw   m0,        m1                         ; [9 8 8 7 7 6 6 5 5 4 4 3 3 2 2 1]
    palignr     m1,        m2, m0, 2                  ; [10 9 9 8 8 7 7 6 6 5 5 4 4 3 3 2]

    pmaddubsw   m4,        m0, [r3 + 4 * 16]          ; [26]
    pmulhrsw    m4,        m3
    pmaddubsw   m1,        [r3 - 2 * 16]              ; [20]
    pmulhrsw    m1,        m3
    packuswb    m4,        m1

    palignr     m5,        m2, m0, 4                  ; [11 10 10 9 9 8 8 7 7 6 6 5 5 4 4 3]

    pmaddubsw   m5,        [r3 - 8 * 16]              ; [14]
    pmulhrsw    m5,        m3

    palignr     m6,        m2, m0, 6                  ; [12 11 11 10 10 9 9 8 8 7 7 6 6 5 5 4]

    pmaddubsw   m6,        [r4]                       ; [ 8]
    pmulhrsw    m6,        m3
    packuswb    m5,        m6

    palignr     m1,        m2, m0, 8                  ; [13 12 12 11 11 10 10 9 9 8 8 7 7 6 6 5]

    pmaddubsw   m6,        m1, [r4 - 6 * 16]          ; [ 2]
    pmulhrsw    m6,        m3

    pmaddubsw   m1,        [r3 + 6 * 16]              ; [28]
    pmulhrsw    m1,        m3
    packuswb    m6,        m1

    palignr     m1,        m2, m0, 10                 ; [14 13 13 12 12 11 11 10 10 9 9 8 8 7 7 6]

    pmaddubsw   m1,        [r3]                       ; [22]
    pmulhrsw    m1,        m3

    palignr     m2,        m0, 12                     ; [15 14 14 13 13 12 12 11 11 10 10 9 9 8 8 7]

    pmaddubsw   m2,        [r3 - 6 * 16]              ; [16]
    pmulhrsw    m2,        m3
    packuswb    m1,        m2
    jmp         .transpose8x8

ALIGN 16
.transpose8x8:
    jz         .store

    ; transpose 8x8
    punpckhbw   m0,        m4, m5
    punpcklbw   m4,        m5
    punpckhbw   m2,        m4, m0
    punpcklbw   m4,        m0

    punpckhbw   m0,        m6, m1
    punpcklbw   m6,        m1
    punpckhbw   m1,        m6, m0
    punpcklbw   m6,        m0

    punpckhdq   m5,        m4, m6
    punpckldq   m4,        m6
    punpckldq   m6,        m2, m1
    punpckhdq   m2,        m1
    mova        m1,        m2

.store:
    lea         r4,              [r1 * 3]
    movh        [r0],            m4
    movhps      [r0 + r1],       m4
    movh        [r0 + r1 * 2],   m5
    movhps      [r0 + r4],       m5
    add         r0,              r4
    movh        [r0 + r1],       m6
    movhps      [r0 + r1 * 2],   m6
    movh        [r0 + r4],       m1
    movhps      [r0 + r1 * 4],   m1
    RET

cglobal intra_pred_ang8_4, 3,5,8
    lea         r4,        [r2 + 1]
    add         r2,        17
    cmp         r3m,       byte 32
    cmove       r2,        r4
    lea         r3,        [ang_table + 24 * 16]
    lea         r4,        [ang_table + 10 * 16]
    mova        m3,        [pw_1024]

    movu        m0,        [r2]                       ; [16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1]
    palignr     m1,        m0, 1                      ; [x 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2]

    punpckhbw   m2,        m0, m1                     ; [x 16 16 15 15 14 14 13 13 12 12 11 11 10 10 9]
    punpcklbw   m0,        m1                         ; [9 8 8 7 7 6 6 5 5 4 4 3 3 2 2 1]
    palignr     m1,        m2, m0, 2                  ; [10 9 9 8 8 7 7 6 6 5 5 4 4 3 3 2]
    mova        m5,        m1

    pmaddubsw   m4,        m0, [r3 - 3 * 16]          ; [21]
    pmulhrsw    m4,        m3
    pmaddubsw   m1,        [r4]                       ; [10]
    pmulhrsw    m1,        m3
    packuswb    m4,        m1

    pmaddubsw   m5,        [r3 + 7 * 16]              ; [31]
    pmulhrsw    m5,        m3

    palignr     m6,        m2, m0, 4                  ; [11 10 10 9 9 8 8 7 7 6 6 5 5 4 4 3]

    pmaddubsw   m6,        [r3 - 4 * 16]              ; [ 20]
    pmulhrsw    m6,        m3
    packuswb    m5,        m6

    palignr     m1,        m2, m0, 6                  ; [12 11 11 10 10 9 9 8 8 7 7 6 6 5 5 4]

    pmaddubsw   m6,        m1, [r4 - 1 * 16]          ; [ 9]
    pmulhrsw    m6,        m3

    pmaddubsw   m1,        [r3 + 6 * 16]              ; [30]
    pmulhrsw    m1,        m3
    packuswb    m6,        m1

    palignr     m1,        m2, m0, 8                  ; [13 12 12 11 11 10 10 9 9 8 8 7 7 6 6 5]

    pmaddubsw   m1,        [r3 - 5 * 16]              ; [19]
    pmulhrsw    m1,        m3

    palignr     m2,        m0, 10                     ; [14 13 13 12 12 11 11 10 10 9 9 8 8 7 7 8]

    pmaddubsw   m2,        [r4 - 2 * 16]              ; [8]
    pmulhrsw    m2,        m3
    packuswb    m1,        m2
    jmp         mangle(private_prefix %+ _ %+ intra_pred_ang8_3 %+ SUFFIX %+ .transpose8x8)

cglobal intra_pred_ang8_5, 3,5,8
    lea         r4,        [r2 + 1]
    add         r2,        17
    cmp         r3m,       byte 31
    cmove       r2,        r4
    lea         r3,        [ang_table + 17 * 16]
    lea         r4,        [ang_table +  2 * 16]
    mova        m3,        [pw_1024]

    movu        m0,        [r2]                       ; [16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1]
    palignr     m1,        m0, 1                      ; [x 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2]

    punpckhbw   m2,        m0, m1                     ; [x 16 16 15 15 14 14 13 13 12 12 11 11 10 10 9]
    punpcklbw   m0,        m1                         ; [9 8 8 7 7 6 6 5 5 4 4 3 3 2 2 1]
    palignr     m1,        m2, m0, 2                  ; [10 9 9 8 8 7 7 6 6 5 5 4 4 3 3 2]
    mova        m5,        m1

    pmaddubsw   m4,        m0, [r3]                   ; [17]
    pmulhrsw    m4,        m3
    pmaddubsw   m1,        [r4]                       ; [2]
    pmulhrsw    m1,        m3
    packuswb    m4,        m1

    pmaddubsw   m5,        [r3 + 2 * 16]              ; [19]
    pmulhrsw    m5,        m3

    palignr     m6,        m2, m0, 4                  ; [11 10 10 9 9 8 8 7 7 6 6 5 5 4 4 3]
    mova        m1,        m6

    pmaddubsw   m1,        [r4 + 2 * 16]              ; [4]
    pmulhrsw    m1,        m3
    packuswb    m5,        m1

    pmaddubsw   m6,        [r3 + 4 * 16]              ; [21]
    pmulhrsw    m6,        m3

    palignr     m1,        m2, m0, 6                  ; [12 11 11 10 10 9 9 8 8 7 7 6 6 5 5 4]

    mova        m7,        m1
    pmaddubsw   m7,        [r4 + 4 * 16]              ; [6]
    pmulhrsw    m7,        m3
    packuswb    m6,        m7

    pmaddubsw   m1,        [r3 + 6 * 16]              ; [23]
    pmulhrsw    m1,        m3

    palignr     m2,        m0, 8                      ; [13 12 12 11 11 10 10 9 9 8 8 7 7 8 8 9]

    pmaddubsw   m2,        [r4 + 6 * 16]              ; [8]
    pmulhrsw    m2,        m3
    packuswb    m1,        m2
    jmp         mangle(private_prefix %+ _ %+ intra_pred_ang8_3 %+ SUFFIX %+ .transpose8x8)

cglobal intra_pred_ang8_6, 3,5,8
    lea         r4,        [r2 + 1]
    add         r2,        17
    cmp         r3m,       byte 30
    cmove       r2,        r4
    lea         r3,        [ang_table + 20 * 16]
    lea         r4,        [ang_table +  8 * 16]
    mova        m7,        [pw_1024]

    movu        m0,        [r2]                       ; [16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1]
    palignr     m1,        m0, 1                      ; [x 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2]

    punpckhbw   m2,        m0, m1                     ; [x 16 16 15 15 14 14 13 13 12 12 11 11 10 10 9]
    punpcklbw   m0,        m1                         ; [9 8 8 7 7 6 6 5 5 4 4 3 3 2 2 1]
    mova        m1,        m0

    pmaddubsw   m4,        m0, [r3 - 7 * 16]          ; [13]
    pmulhrsw    m4,        m7
    pmaddubsw   m1,        [r3 + 6 * 16]              ; [26]
    pmulhrsw    m1,        m7
    packuswb    m4,        m1

    palignr     m6,        m2, m0, 2                  ; [10 9 9 8 8 7 7 6 6 5 5 4 4 3 3 2]

    pmaddubsw   m5,        m6, [r4 - 1 * 16]          ; [7]
    pmulhrsw    m5,        m7

    pmaddubsw   m6,        [r3]                       ; [20]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    palignr     m1,        m2, m0, 4                  ; [11 10 10 9 9 8 8 7 7 6 6 5 5 4 4 3]

    pmaddubsw   m6,        m1, [r4 - 7 * 16]          ; [1]
    pmulhrsw    m6,        m7

    mova        m3,        m1
    pmaddubsw   m3,        [r3 - 6 * 16]              ; [14]
    pmulhrsw    m3,        m7
    packuswb    m6,        m3

    pmaddubsw   m1,        [r3 + 7 * 16]              ; [27]
    pmulhrsw    m1,        m7

    palignr     m2,        m0, 6                      ; [12 11 11 10 10 9 9 8 8 7 7 6 6 5 5 4]

    pmaddubsw   m2,        [r4]                       ; [8]
    pmulhrsw    m2,        m7
    packuswb    m1,        m2
    jmp         mangle(private_prefix %+ _ %+ intra_pred_ang8_3 %+ SUFFIX %+ .transpose8x8)

cglobal intra_pred_ang8_7, 3,5,8
    lea         r4,        [r2 + 1]
    add         r2,        17
    cmp         r3m,       byte 29
    cmove       r2,        r4
    lea         r3,        [ang_table + 24 * 16]
    lea         r4,        [ang_table +  6 * 16]
    mova        m7,        [pw_1024]

    movu        m0,        [r2]                       ; [16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1]
    palignr     m1,        m0, 1                      ; [x 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2]

    punpckhbw   m2,        m0, m1                     ; [x 16 16 15 15 14 14 13 13 12 12 11 11 10 10 9]
    punpcklbw   m0,        m1                         ; [9 8 8 7 7 6 6 5 5 4 4 3 3 2 2 1]

    pmaddubsw   m4,        m0, [r4 + 3 * 16]          ; [9]
    pmulhrsw    m4,        m7
    pmaddubsw   m3,        m0, [r3 - 6 * 16]          ; [18]
    pmulhrsw    m3,        m7
    packuswb    m4,        m3

    pmaddubsw   m5,        m0, [r3 + 3 * 16]          ; [27]
    pmulhrsw    m5,        m7

    palignr     m1,        m2, m0, 2                  ; [10 9 9 8 8 7 7 6 6 5 5 4 4 3 3 2]

    pmaddubsw   m6,        m1, [r4 - 2 * 16]          ; [4]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pmaddubsw   m6,        m1, [r4 + 7 * 16]          ; [13]
    pmulhrsw    m6,        m7

    mova        m3,        m1
    pmaddubsw   m3,        [r3 - 2 * 16]              ; [22]
    pmulhrsw    m3,        m7
    packuswb    m6,        m3

    pmaddubsw   m1,        [r3 + 7 * 16]              ; [31]
    pmulhrsw    m1,        m7

    palignr     m2,        m0, 4                      ; [11 10 10 9 9 8 8 7 7 6 6 5 5 4 4 3]

    pmaddubsw   m2,        [r4 + 2 * 16]              ; [8]
    pmulhrsw    m2,        m7
    packuswb    m1,        m2
    jmp         mangle(private_prefix %+ _ %+ intra_pred_ang8_3 %+ SUFFIX %+ .transpose8x8)

cglobal intra_pred_ang8_8, 3,5,8
    lea         r4,        [r2 + 1]
    add         r2,        17
    cmp         r3m,       byte 28
    cmove       r2,        r4
    lea         r3,        [ang_table + 23 * 16]
    lea         r4,        [ang_table +  8 * 16]
    mova        m7,        [pw_1024]

    movu        m0,        [r2]                       ; [16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1]
    palignr     m1,        m0, 1                      ; [x 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2]

    punpckhbw   m2,        m0, m1                     ; [x 16 16 15 15 14 14 13 13 12 12 11 11 10 10 9]
    punpcklbw   m0,        m1                         ; [9 8 8 7 7 6 6 5 5 4 4 3 3 2 2 1]
    palignr     m2,        m0, 2                      ; [10 9 9 8 8 7 7 6 6 5 5 4 4 3 3 2]

    pmaddubsw   m4,        m0, [r4 - 3 * 16]          ; [5]
    pmulhrsw    m4,        m7
    pmaddubsw   m3,        m0, [r4 + 2 * 16]          ; [10]
    pmulhrsw    m3,        m7
    packuswb    m4,        m3

    pmaddubsw   m5,        m0, [r3 - 8 * 16]          ; [15]
    pmulhrsw    m5,        m7

    pmaddubsw   m6,        m0, [r3 - 3 * 16]          ; [20]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pmaddubsw   m6,        m0, [r3 + 2 * 16]          ; [25]
    pmulhrsw    m6,        m7

    pmaddubsw   m0,        [r3 + 7 * 16]              ; [30]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0

    pmaddubsw   m1,        m2, [r4 - 5 * 16]          ; [3]
    pmulhrsw    m1,        m7

    pmaddubsw   m2,        [r4]                       ; [8]
    pmulhrsw    m2,        m7
    packuswb    m1,        m2
    jmp         mangle(private_prefix %+ _ %+ intra_pred_ang8_3 %+ SUFFIX %+ .transpose8x8)

cglobal intra_pred_ang8_9, 3,5,8
    lea         r4,        [r2 + 1]
    add         r2,        17
    cmp         r3m,       byte 27
    cmove       r2,        r4
    lea         r3,        [ang_table + 10 * 16]
    mova        m7,        [pw_1024]

    movu        m0,        [r2]                       ; [16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1]
    palignr     m1,        m0, 1                      ; [x 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2]

    punpcklbw   m0,        m1                         ; [9 8 8 7 7 6 6 5 5 4 4 3 3 2 2 1]

    pmaddubsw   m4,        m0, [r3 - 8 * 16]          ; [2]
    pmulhrsw    m4,        m7
    pmaddubsw   m3,        m0, [r3 - 6 * 16]          ; [4]
    pmulhrsw    m3,        m7
    packuswb    m4,        m3

    pmaddubsw   m5,        m0, [r3 - 4 * 16]          ; [6]
    pmulhrsw    m5,        m7

    pmaddubsw   m6,        m0, [r3 - 2 * 16]          ; [8]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pmaddubsw   m6,        m0, [r3]                   ; [10]
    pmulhrsw    m6,        m7

    pmaddubsw   m2,        m0, [r3 + 2 * 16]          ; [12]
    pmulhrsw    m2,        m7
    packuswb    m6,        m2

    pmaddubsw   m1,        m0, [r3 + 4 * 16]          ; [14]
    pmulhrsw    m1,        m7

    pmaddubsw   m0,        [r3 + 6 * 16]              ; [16]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0
    jmp         mangle(private_prefix %+ _ %+ intra_pred_ang8_3 %+ SUFFIX %+ .transpose8x8)

cglobal intra_pred_ang8_10, 3,6,5
    movh        m0,        [r2 + 17]
    mova        m4,        [pb_unpackbq]
    palignr     m1,        m0, 2
    pshufb      m1,        m4
    palignr     m2,        m0, 4
    pshufb      m2,        m4
    palignr     m3,        m0, 6
    pshufb      m3,        m4
    pshufb      m0,        m4

    lea         r5,             [r1 * 3]
    movhps      [r0 + r1],      m0
    movh        [r0 + r1 * 2],  m1
    movhps      [r0 + r5],      m1
    lea         r3,             [r0 + r1 * 4]
    movh        [r3],           m2
    movhps      [r3 + r1],      m2
    movh        [r3 + r1 * 2],  m3
    movhps      [r3 + r5],      m3

; filter
    cmp         r4m, byte 0
    jz         .quit

    pmovzxbw    m0,        m0
    movu        m1,        [r2]
    palignr     m2,        m1, 1
    pshufb      m1,        m4
    pmovzxbw    m1,        m1
    pmovzxbw    m2,        m2
    psubw       m2,        m1
    psraw       m2,        1
    paddw       m0,        m2
    packuswb    m0,        m0

.quit:
    movh        [r0],      m0
    RET

cglobal intra_pred_ang8_26, 3,6,3
    movu        m2,             [r2]
    palignr     m0,             m2, 1
    lea         r5,             [r1 * 3]
    movh        [r0],           m0
    movh        [r0 + r1],      m0
    movh        [r0 + r1 * 2],  m0
    movh        [r0 + r5],      m0
    lea         r3,             [r0 + r1 * 4]
    movh        [r3],           m0
    movh        [r3 + r1],      m0
    movh        [r3 + r1 * 2],  m0
    movh        [r3 + r5],      m0

; filter
    cmp         r4m, byte 0
    jz         .quit

    pshufb      m2,        [pb_unpackbq]
    movhlps     m1,        m2
    pmovzxbw    m2,        m2
    movu        m0,        [r2 + 17]
    pmovzxbw    m1,        m1
    pmovzxbw    m0,        m0
    psubw       m0,        m2
    psraw       m0,        1
    paddw       m1,        m0
    packuswb    m1,        m1
    pextrb      [r0],          m1, 0
    pextrb      [r0 + r1],     m1, 1
    pextrb      [r0 + r1 * 2], m1, 2
    pextrb      [r0 + r5],     m1, 3
    pextrb      [r3],          m1, 4
    pextrb      [r3 + r1],     m1, 5
    pextrb      [r3 + r1 * 2], m1, 6
    pextrb      [r3 + r5],     m1, 7
.quit:
    RET

cglobal intra_pred_ang8_11, 3,5,8
    xor         r4,        r4
    cmp         r3m,       byte 25
    mov         r3,        16
    cmove       r3,        r4

    movu        m0,        [r2 + r3]                  ; [15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0]
    pinsrb      m0,        [r2], 0
    palignr     m1,        m0, 1                      ; [x 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1]

    punpcklbw   m0,        m1                         ; [8 7 7 6 6 5 5 4 4 3 3 2 2 1 1 0]

    lea         r3,        [ang_table + 23 * 16]
    mova        m7,        [pw_1024]

    pmaddubsw   m4,        m0, [r3 + 7 * 16]          ; [30]
    pmulhrsw    m4,        m7
    pmaddubsw   m3,        m0, [r3 + 5 * 16]          ; [28]
    pmulhrsw    m3,        m7
    packuswb    m4,        m3

    pmaddubsw   m5,        m0, [r3 + 3 * 16]          ; [26]
    pmulhrsw    m5,        m7

    pmaddubsw   m6,        m0, [r3 + 1 * 16]          ; [24]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pmaddubsw   m6,        m0, [r3 - 1 * 16]          ; [22]
    pmulhrsw    m6,        m7

    pmaddubsw   m2,        m0, [r3 - 3 * 16]          ; [20]
    pmulhrsw    m2,        m7
    packuswb    m6,        m2

    pmaddubsw   m1,        m0, [r3 - 5 * 16]          ; [18]
    pmulhrsw    m1,        m7

    pmaddubsw   m0,        [r3 - 7 * 16]              ; [16]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0
    jmp         mangle(private_prefix %+ _ %+ intra_pred_ang8_3 %+ SUFFIX %+ .transpose8x8)

cglobal intra_pred_ang8_12, 3,5,8
    xor         r4,        r4
    cmp         r3m,       byte 24
    mov         r3,        16
    jz          .next
    xchg        r3,        r4
.next:

    movu        m1,        [r2 + r4]                  ; [15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0]
    pinsrb      m1,        [r2], 0
    pslldq      m0,        m1, 1                      ; [14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 a]
    pinsrb      m0,        [r2 + r3 + 6], 0

    lea         r4,        [ang_table + 22 * 16]
    mova        m7,        [pw_1024]

    punpckhbw   m2,        m0, m1                     ; [15 14 14 13 13 12 12 11 11 10 10 9 9 8 8 7]
    punpcklbw   m0,        m1                         ; [7 6 6 5 5 4 4 3 3 2 2 1 1 0 0 a]
    palignr     m2,        m0, 2                      ; [8 7 7 6 6 5 5 4 4 3 3 2 2 1 1 0]

    pmaddubsw   m4,        m2, [r4 + 5 * 16]          ; [27]
    pmulhrsw    m4,        m7
    pmaddubsw   m3,        m2, [r4]                   ; [22]
    pmulhrsw    m3,        m7
    packuswb    m4,        m3

    pmaddubsw   m1,        m0, [r4 + 7 * 16]          ; [29]
    pmulhrsw    m1,        m7

    pmaddubsw   m0,        [r4 + 2 * 16]              ; [24]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0

    pmaddubsw   m5,        m2, [r4 - 5 * 16]          ; [17]
    pmulhrsw    m5,        m7

    lea         r4,        [ang_table + 7 * 16]
    pmaddubsw   m6,        m2, [r4 + 5 * 16]          ; [12]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pmaddubsw   m6,        m2, [r4]                   ; [7]
    pmulhrsw    m6,        m7

    pmaddubsw   m2,        [r4 - 5 * 16]              ; [2]
    pmulhrsw    m2,        m7
    packuswb    m6,        m2
    jmp         mangle(private_prefix %+ _ %+ intra_pred_ang8_3 %+ SUFFIX %+ .transpose8x8)

cglobal intra_pred_ang8_13, 4,5,8
    xor         r4,        r4
    cmp         r3m,       byte 23
    mov         r3,        16
    jz          .next
    xchg        r3,        r4
.next:

    movu        m1,        [r2 +  r4]                 ; [15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0]
    pinsrb      m1,        [r2], 0
    pslldq      m1,        1                          ; [14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 a]
    pinsrb      m1,        [r2 + r3 + 4], 0
    pslldq      m0,        m1, 1                      ; [13 12 11 10 9 8 7 6 5 4 3 2 1 0 a b]
    pinsrb      m0,        [r2 + r3 + 7], 0
    punpckhbw   m5,        m0, m1                     ; [14 13 13 12 12 11 11 10 10 9 9 8 8 7 7 6]
    punpcklbw   m0,        m1                         ; [6 5 5 4 4 3 3 2 2 1 1 0 0 a a b]
    palignr     m1,        m5, m0, 2                  ; [7 6 6 5 5 4 4 3 3 2 2 1 1 0 0 a]
    palignr     m5,        m0, 4                      ; [8 7 7 6 6 5 5 4 4 3 3 2 2 1 1 0]

    lea         r4,        [ang_table + 24 * 16]
    mova        m7,        [pw_1024]

    pmaddubsw   m4,        m5, [r4 - 1 * 16]          ; [23]
    pmulhrsw    m4,        m7

    pmaddubsw   m6,        m1, [r4 + 4 * 16]          ; [28]
    pmulhrsw    m6,        m7

    pmaddubsw   m0,        [r4]                       ; [24]
    pmulhrsw    m0,        m7

    lea         r4,        [ang_table + 13 * 16]
    pmaddubsw   m3,        m5, [r4 + 1 * 16]          ; [14]
    pmulhrsw    m3,        m7
    packuswb    m4,        m3

    pmaddubsw   m5,        [r4 - 8 * 16]              ; [5]
    pmulhrsw    m5,        m7
    packuswb    m5,        m6

    pmaddubsw   m6,        m1, [r4 + 6 * 16]          ; [19]
    pmulhrsw    m6,        m7

    pmaddubsw   m2,        m1, [r4 - 3 * 16]          ; [10]
    pmulhrsw    m2,        m7
    packuswb    m6,        m2

    pmaddubsw   m1,        [r4 - 12 * 16]             ; [1]
    pmulhrsw    m1,        m7
    packuswb    m1,        m0
    jmp         mangle(private_prefix %+ _ %+ intra_pred_ang8_3 %+ SUFFIX %+ .transpose8x8)

cglobal intra_pred_ang8_14, 4,5,8
    xor         r4,        r4
    cmp         r3m,       byte 22
    mov         r3,        16
    jz          .next
    xchg        r3,        r4
.next:

    movu        m1,        [r2 + r4 - 2]              ; [13 12 11 10 9 8 7 6 5 4 3 2 1 0 a b]
    pinsrb      m1,        [r2], 2
    pinsrb      m1,        [r2 + r3 + 2], 1
    pinsrb      m1,        [r2 + r3 + 5], 0
    pslldq      m0,        m1, 1                      ; [12 11 10 9 8 7 6 5 4 3 2 1 0 a b c]
    pinsrb      m0,        [r2 + r3 + 7], 0
    punpckhbw   m2,        m0, m1                     ; [13 12 12 11 11 10 10 9 9 8 8 7 7 6 6 5]
    punpcklbw   m0,        m1                         ; [5 4 4 3 3 2 2 1 1 0 0 a a b b c]
    palignr     m1,        m2, m0, 2                  ; [6 5 5 4 4 3 3 2 2 1 1 0 0 a a b]
    palignr     m6,        m2, m0, 4                  ; [7 6 6 5 5 4 4 3 3 2 2 1 1 0 0 a]
    palignr     m2,        m0, 6                      ; [8 7 7 6 6 5 5 4 4 3 3 2 2 1 1 0]

    lea         r4,        [ang_table + 24 * 16]
    mova        m3,        [pw_1024]

    pmaddubsw   m4,        m2, [r4 - 5 * 16]          ; [19]
    pmulhrsw    m4,        m3

    pmaddubsw   m0,        [r4]                       ; [24]
    pmulhrsw    m0,        m3

    pmaddubsw   m5,        m6, [r4 + 1 * 16]          ; [25]
    pmulhrsw    m5,        m3

    lea         r4,        [ang_table + 12 * 16]
    pmaddubsw   m6,        [r4]                       ; [12]
    pmulhrsw    m6,        m3
    packuswb    m5,        m6

    pmaddubsw   m6,        m1, [r4 + 19 * 16]         ; [31]
    pmulhrsw    m6,        m3

    pmaddubsw   m2,        [r4 - 6 * 16]              ; [6]
    pmulhrsw    m2,        m3
    packuswb    m4,        m2

    pmaddubsw   m2,        m1, [r4 + 6 * 16]          ; [18]
    pmulhrsw    m2,        m3
    packuswb    m6,        m2

    pmaddubsw   m1,        [r4 - 7 * 16]              ; [5]
    pmulhrsw    m1,        m3
    packuswb    m1,        m0
    jmp         mangle(private_prefix %+ _ %+ intra_pred_ang8_3 %+ SUFFIX %+ .transpose8x8)

cglobal intra_pred_ang8_15, 4,5,8
    xor         r4,        r4
    cmp         r3m,       byte 21
    mov         r3,        16
    jz          .next
    xchg        r3,        r4
.next:

    movu        m1,        [r2 + r4]                  ; [15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0]
    pinsrb      m1,        [r2], 0
    movu        m2,        [r2 + r3]
    pshufb      m2,        [c_mode16_15]
    palignr     m1,        m2, 13                     ; [12 11 10 9 8 7 6 5 4 3 2 1 0 a b c]
    pslldq      m0,        m1, 1                      ; [11 10 9 8 7 6 5 4 3 2 1 0 a b c d]
    pinsrb      m0,        [r2 + r3 + 8], 0
    punpckhbw   m4,        m0, m1                     ; [12 11 11 10 10 9 9 8 8 7 7 6 6 5 5 4]
    punpcklbw   m0,        m1                         ; [4 3 3 2 2 1 1 0 0 a a b b c c d]
    palignr     m1,        m4, m0, 2                  ; [5 4 4 3 3 2 2 1 1 0 0 a a b b c]
    palignr     m6,        m4, m0, 4                  ; [6 5 5 4 4 3 3 2 2 1 1 0 0 a a b]
    palignr     m5,        m4, m0, 6                  ; [7 6 6 5 5 4 4 3 3 2 2 1 1 0 0 a]
    palignr     m4,        m0, 8                      ; [8 7 7 6 6 5 5 4 4 3 3 2 2 1 1 0]

    lea         r4,        [ang_table + 23 * 16]
    mova        m3,        [pw_1024]

    pmaddubsw   m4,        [r4 - 8 * 16]              ; [15]
    pmulhrsw    m4,        m3

    pmaddubsw   m2,        m5, [r4 + 7 * 16]          ; [30]
    pmulhrsw    m2,        m3
    packuswb    m4,        m2

    pmaddubsw   m5,        [r4 - 10 * 16]             ; [13]
    pmulhrsw    m5,        m3

    pmaddubsw   m2,        m6, [r4 + 5 * 16]          ; [28]
    pmulhrsw    m2,        m3
    packuswb    m5,        m2

    pmaddubsw   m2,        m1, [r4 + 3 * 16]          ; [26]
    pmulhrsw    m2,        m3

    pmaddubsw   m0,        [r4 + 1 * 16]              ; [24]
    pmulhrsw    m0,        m3

    lea         r4,        [ang_table + 11 * 16]
    pmaddubsw   m6,        [r4]                       ; [11]
    pmulhrsw    m6,        m3
    packuswb    m6,        m2

    pmaddubsw   m1,        [r4 - 2 * 16]              ; [9]
    pmulhrsw    m1,        m3
    packuswb    m1,        m0
    jmp         mangle(private_prefix %+ _ %+ intra_pred_ang8_3 %+ SUFFIX %+ .transpose8x8)

cglobal intra_pred_ang8_16, 4,5,8
    xor         r4,        r4
    cmp         r3m,       byte 20
    mov         r3,        16
    jz          .next
    xchg        r3,        r4
.next:

    movu        m1,        [r2 + r4]                  ; [15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0]
    pinsrb      m1,        [r2], 0
    movu        m2,        [r2 + r3]
    pshufb      m2,        [c_mode16_16]
    palignr     m1,        m2, 12                     ; [11 10 9 8 7 6 5 4 3 2 1 0 a b c d]
    pslldq      m0,        m1, 1                      ; [10 9 8 7 6 5 4 3 2 1 0 a b c d e]
    pinsrb      m0,        [r2 + r3 + 8], 0
    punpckhbw   m4,        m0, m1                     ; [11 10 10 9 9 8 8 7 7 6 6 5 5 4 4 3]
    punpcklbw   m0,        m1                         ; [3 2 2 1 1 0 0 a a b b c c d d e]
    palignr     m1,        m4, m0, 2                  ; [4 3 3 2 2 1 1 0 0 a a b b c c d]
    palignr     m6,        m4, m0, 4                  ; [5 4 4 3 3 2 2 1 1 0 0 a a b b c]
    palignr     m2,        m4, m0, 6                  ; [6 5 5 4 4 3 3 2 2 1 1 0 0 a a b]
    palignr     m5,        m4, m0, 8                  ; [7 6 6 5 5 4 4 3 3 2 2 1 1 0 0 a]
    palignr     m4,        m0, 10                     ; [8 7 7 6 6 5 5 4 4 3 3 2 2 1 1 0]

    lea         r4,        [ang_table + 22 * 16]
    mova        m7,        [pw_1024]

    pmaddubsw   m3,        m5, [r4]                   ; [22]
    pmulhrsw    m3,        m7

    pmaddubsw   m0,        [r4 + 2 * 16]              ; [24]
    pmulhrsw    m0,        m7

    lea         r4,        [ang_table + 9 * 16]

    pmaddubsw   m4,        [r4 + 2 * 16]              ; [11]
    pmulhrsw    m4,        m7
    packuswb    m4,        m3

    pmaddubsw   m2,        [r4 + 3 * 16]              ; [12]
    pmulhrsw    m2,        m7

    pmaddubsw   m5,        [r4 - 8 * 16]              ; [1]
    pmulhrsw    m5,        m7
    packuswb    m5,        m2

    mova        m2,        m6
    pmaddubsw   m6,        [r4 + 14 * 16]             ; [23]
    pmulhrsw    m6,        m7

    pmaddubsw   m2,        [r4 -  7 * 16]             ; [2]
    pmulhrsw    m2,        m7
    packuswb    m6,        m2

    pmaddubsw   m1,        [r4 + 4 * 16]              ; [13]
    pmulhrsw    m1,        m7
    packuswb    m1,        m0
    jmp         mangle(private_prefix %+ _ %+ intra_pred_ang8_3 %+ SUFFIX %+ .transpose8x8)

cglobal intra_pred_ang8_17, 4,5,8
    xor         r4,        r4
    cmp         r3m,       byte 19
    mov         r3,        16
    jz          .next
    xchg        r3,        r4
.next:

    movu        m2,        [r2 + r4]                  ; [15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0]
    pinsrb      m2,        [r2], 0
    movu        m1,        [r2 + r3]
    pshufb      m1,        [c_mode16_17]
    palignr     m2,        m1, 11                     ; [10 9 8 7 6 5 4 3 2 1 0 a b c d e]
    pslldq      m0,        m2, 1                      ; [9 8 7 6 5 4 3 2 1 0 a b c d e f]
    pinsrb      m0,        [r2 + r3 + 7], 0
    punpckhbw   m1,        m0, m2                     ; [10 9 9 8 8 7 7 6 6 5 5 4 4 3 3 2]
    punpcklbw   m0,        m2                         ; [2 1 1 0 0 a a b b c c d d e e f]

    palignr     m5,        m1, m0, 8                  ; [6 5 5 4 4 3 3 2 2 1 1 0 0 a a b]
    palignr     m2,        m1, m0, 10                 ; [7 6 6 5 5 4 4 3 3 2 2 1 1 0 0 a]
    palignr     m4,        m1, m0, 12                 ; [8 7 7 6 6 5 5 4 4 3 3 2 2 1 1 0]

    lea         r4,        [ang_table + 17 * 16]
    mova        m3,        [pw_1024]

    pmaddubsw   m2,        [r4 - 5 * 16]              ; [12]
    pmulhrsw    m2,        m3

    pmaddubsw   m4,        [r4 - 11 * 16]             ; [6]
    pmulhrsw    m4,        m3
    packuswb    m4,        m2

    pmaddubsw   m5,        [r4 + 1 * 16]              ; [18]
    pmulhrsw    m5,        m3

    palignr     m2,        m1, m0, 6                  ; [5 4 4 3 3 2 2 1 1 0 0 a a b b c]
    pmaddubsw   m2,        [r4 + 7 * 16]              ; [24]
    pmulhrsw    m2,        m3
    packuswb    m5,        m2

    palignr     m6,        m1, m0, 4                  ; [4 3 3 2 2 1 1 0 0 a a b b c c d]
    mova        m2,        m6
    pmaddubsw   m6,        [r4 + 13 * 16]             ; [30]
    pmulhrsw    m6,        m3

    pmaddubsw   m2,        [r4 - 13 * 16]             ; [4]
    pmulhrsw    m2,        m3
    packuswb    m6,        m2

    palignr     m1,        m0, 2                      ; [3 2 2 1 1 0 0 a a b b c c d d e]
    pmaddubsw   m1,        [r4 - 7 * 16]              ; [10]
    pmulhrsw    m1,        m3

    pmaddubsw   m0,        [r4 - 1 * 16]              ; [16]
    pmulhrsw    m0,        m3
    packuswb    m1,        m0
    jmp         mangle(private_prefix %+ _ %+ intra_pred_ang8_3 %+ SUFFIX %+ .transpose8x8)

cglobal intra_pred_ang8_18, 4,4,1
    movu        m0, [r2 + 16]
    pinsrb      m0, [r2], 0
    pshufb      m0, [pb_swap8]
    movhps      m0, [r2 + 1]
    lea         r2, [r0 + r1 * 4]
    lea         r3, [r1 * 3]
    movh        [r2 + r3], m0
    psrldq      m0, 1
    movh        [r2 + r1 * 2], m0
    psrldq      m0, 1
    movh        [r2 + r1], m0
    psrldq      m0, 1
    movh        [r2], m0
    psrldq      m0, 1
    movh        [r0 + r3], m0
    psrldq      m0, 1
    movh        [r0 + r1 * 2], m0
    psrldq      m0, 1
    movh        [r0 + r1], m0
    psrldq      m0, 1
    movh        [r0], m0
    RET

%macro TRANSPOSE_STORE_8x8 6
  %if %2 == 1
    ; transpose 8x8 and then store, used by angle BLOCK_16x16 and BLOCK_32x32
    punpckhbw   m0,        %3, %4
    punpcklbw   %3,        %4
    punpckhbw   %4,        %3, m0
    punpcklbw   %3,        m0

    punpckhbw   m0,        %5, m1
    punpcklbw   %5,        %6
    punpckhbw   %6,        %5, m0
    punpcklbw   %5,        m0

    punpckhdq   m0,        %3, %5
    punpckldq   %3,        %5
    punpckldq   %5,        %4, %6
    punpckhdq   %4,        %6

    movh        [r0 +       + %1 * 8], %3
    movhps      [r0 +  r1   + %1 * 8], %3
    movh        [r0 +  r1*2 + %1 * 8], m0
    movhps      [r0 +  r5   + %1 * 8], m0
    movh        [r6         + %1 * 8], %5
    movhps      [r6 +  r1   + %1 * 8], %5
    movh        [r6 +  r1*2 + %1 * 8], %4
    movhps      [r6 +  r5   + %1 * 8], %4
  %else
    ; store 8x8, used by angle BLOCK_16x16 and BLOCK_32x32
    movh        [r0         ], %3
    movhps      [r0 + r1    ], %3
    movh        [r0 + r1 * 2], %4
    movhps      [r0 + r5    ], %4
    lea         r0, [r0 + r1 * 4]
    movh        [r0         ], %5
    movhps      [r0 + r1    ], %5
    movh        [r0 + r1 * 2], %6
    movhps      [r0 + r5    ], %6
    lea         r0, [r0 + r1 * 4]
  %endif
%endmacro

;------------------------------------------------------------------------------------------
; void intraPredAng16(pixel* dst, intptr_t dstStride, pixel* src, int dirMode, int bFilter)
;------------------------------------------------------------------------------------------
INIT_XMM ssse3
cglobal intra_pred_ang16_2, 3,5,3
    lea             r4, [r2 + 2]
    add             r2, 34
    cmp             r3m, byte 34
    cmove           r2, r4
    movu            m0, [r2]
    movu            m1, [r2 + 16]
    movu            [r0], m0
    palignr         m2, m1, m0, 1
    movu            [r0 + r1], m2
    lea             r0, [r0 + r1 * 2]
    palignr         m2, m1, m0, 2
    movu            [r0], m2
    palignr         m2, m1, m0, 3
    movu            [r0 + r1], m2
    lea             r0, [r0 + r1 * 2]
    palignr         m2, m1, m0, 4
    movu            [r0], m2
    palignr         m2, m1, m0, 5
    movu            [r0 + r1], m2
    lea             r0, [r0 + r1 * 2]
    palignr         m2, m1, m0, 6
    movu            [r0], m2
    palignr         m2, m1, m0, 7
    movu            [r0 + r1], m2
    lea             r0, [r0 + r1 * 2]
    palignr         m2, m1, m0, 8
    movu            [r0], m2
    palignr         m2, m1, m0, 9
    movu            [r0 + r1], m2
    lea             r0, [r0 + r1 * 2]
    palignr         m2, m1, m0, 10
    movu            [r0], m2
    palignr         m2, m1, m0, 11
    movu            [r0 + r1], m2
    lea             r0, [r0 + r1 * 2]
    palignr         m2, m1, m0, 12
    movu            [r0], m2
    palignr         m2, m1, m0, 13
    movu            [r0 + r1], m2
    lea             r0, [r0 + r1 * 2]
    palignr         m2, m1, m0, 14
    movu            [r0], m2
    palignr         m2, m1, m0, 15
    movu            [r0 + r1], m2
    RET

INIT_XMM sse4
cglobal intra_pred_ang16_3, 3,7,8
    add         r2,        32
    lea         r3,        [ang_table + 16 * 16]
    mov         r4d,       2
    lea         r5,        [r1 * 3]                   ; r5 -> 3 * stride
    lea         r6,        [r0 + r1 * 4]              ; r6 -> 4 * stride
    mova        m7,        [pw_1024]

.loop:
    movu        m0,        [r2 + 1]
    palignr     m1,        m0, 1

    punpckhbw   m2,        m0, m1
    punpcklbw   m0,        m1
    palignr     m1,        m2, m0, 2

    pmaddubsw   m4,        m0, [r3 + 10 * 16]         ; [26]
    pmulhrsw    m4,        m7
    pmaddubsw   m1,        [r3 + 4 * 16]              ; [20]
    pmulhrsw    m1,        m7
    packuswb    m4,        m1

    palignr     m5,        m2, m0, 4

    pmaddubsw   m5,        [r3 - 2 * 16]              ; [14]
    pmulhrsw    m5,        m7

    palignr     m6,        m2, m0, 6

    pmaddubsw   m6,        [r3 - 8 * 16]              ; [ 8]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    palignr     m1,        m2, m0, 8

    pmaddubsw   m6,        m1, [r3 - 14 * 16]         ; [ 2]
    pmulhrsw    m6,        m7

    pmaddubsw   m1,        [r3 + 12 * 16]             ; [28]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1

    palignr     m1,        m2, m0, 10

    pmaddubsw   m1,        [r3 + 6 * 16]              ; [22]
    pmulhrsw    m1,        m7

    palignr     m2,        m0, 12

    pmaddubsw   m2,        [r3]                       ; [16]
    pmulhrsw    m2,        m7
    packuswb    m1,        m2

    TRANSPOSE_STORE_8x8 0, 1, m4, m5, m6, m1

    movu        m0,        [r2 + 8]
    palignr     m1,        m0, 1

    punpckhbw   m2,        m0, m1
    punpcklbw   m0,        m1
    palignr     m5,        m2, m0, 2

    pmaddubsw   m4,        m0, [r3 - 6 * 16]          ; [10]
    pmulhrsw    m4,        m7
    pmaddubsw   m1,        m5, [r3 - 12 * 16]         ; [04]
    pmulhrsw    m1,        m7
    packuswb    m4,        m1

    pmaddubsw   m5,        [r3 + 14 * 16]             ; [30]
    pmulhrsw    m5,        m7

    palignr     m6,        m2, m0, 4

    pmaddubsw   m6,        [r3 + 8 * 16]              ; [24]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    palignr     m1,        m2, m0, 6

    pmaddubsw   m6,        m1, [r3 + 2 * 16]          ; [18]
    pmulhrsw    m6,        m7

    palignr     m1,        m2, m0, 8

    pmaddubsw   m1,        [r3 - 4 * 16]              ; [12]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1

    palignr     m1,        m2, m0, 10

    pmaddubsw   m1,        [r3 - 10 * 16]             ; [06]
    pmulhrsw    m1,        m7
    packuswb    m1,        m1

    movhps      m1,        [r2 + 14]                  ; [00]

    TRANSPOSE_STORE_8x8 1, 1, m4, m5, m6, m1

    lea         r0,        [r6 + r1 * 4]
    lea         r6,        [r6 + r1 * 8]
    add         r2,        8
    dec         r4
    jnz        .loop
    RET

INIT_XMM sse4
cglobal intra_pred_ang16_33, 3,7,8
    lea         r3,        [ang_table + 16 * 16]
    mov         r4d,       2
    lea         r5,        [r1 * 3]
    mov         r6,        r0
    mova        m7,        [pw_1024]

.loop:
    movu        m0,        [r2 + 1]
    palignr     m1,        m0, 1

    punpckhbw   m2,        m0, m1
    punpcklbw   m0,        m1
    palignr     m1,        m2, m0, 2

    pmaddubsw   m4,        m0, [r3 + 10 * 16]         ; [26]
    pmulhrsw    m4,        m7
    pmaddubsw   m1,        [r3 + 4 * 16]              ; [20]
    pmulhrsw    m1,        m7
    packuswb    m4,        m1

    palignr     m5,        m2, m0, 4

    pmaddubsw   m5,        [r3 - 2 * 16]              ; [14]
    pmulhrsw    m5,        m7

    palignr     m6,        m2, m0, 6

    pmaddubsw   m6,        [r3 - 8 * 16]              ; [ 8]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    palignr     m1,        m2, m0, 8

    pmaddubsw   m6,        m1, [r3 - 14 * 16]         ; [ 2]
    pmulhrsw    m6,        m7

    pmaddubsw   m1,        [r3 + 12 * 16]             ; [28]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1

    palignr     m1,        m2, m0, 10

    pmaddubsw   m1,        [r3 + 6 * 16]              ; [22]
    pmulhrsw    m1,        m7

    palignr     m2,        m0, 12

    pmaddubsw   m2,        [r3]                       ; [16]
    pmulhrsw    m2,        m7
    packuswb    m1,        m2

    TRANSPOSE_STORE_8x8 0, 0, m4, m5, m6, m1

    movu        m0,        [r2 + 8]
    palignr     m1,        m0, 1

    punpckhbw   m2,        m0, m1
    punpcklbw   m0,        m1
    palignr     m5,        m2, m0, 2

    pmaddubsw   m4,        m0, [r3 - 6 * 16]          ; [10]
    pmulhrsw    m4,        m7
    pmaddubsw   m1,        m5, [r3 - 12 * 16]         ; [04]
    pmulhrsw    m1,        m7
    packuswb    m4,        m1

    pmaddubsw   m5,        [r3 + 14 * 16]             ; [30]
    pmulhrsw    m5,        m7

    palignr     m6,        m2, m0, 4

    pmaddubsw   m6,        [r3 + 8 * 16]              ; [24]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    palignr     m1,        m2, m0, 6

    pmaddubsw   m6,        m1, [r3 + 2 * 16]          ; [18]
    pmulhrsw    m6,        m7

    palignr     m1,        m2, m0, 8

    pmaddubsw   m1,        [r3 - 4 * 16]              ; [12]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1

    palignr     m1,        m2, m0, 10

    pmaddubsw   m1,        [r3 - 10 * 16]             ; [06]
    pmulhrsw    m1,        m7
    packuswb    m1,        m1

    movh        m2,        [r2 + 14]                  ; [00]

    movh        [r0         ], m4
    movhps      [r0 + r1    ], m4
    movh        [r0 + r1 * 2], m5
    movhps      [r0 + r5    ], m5
    lea         r0, [r0 + r1 * 4]
    movh        [r0         ], m6
    movhps      [r0 + r1    ], m6
    movh        [r0 + r1 * 2], m1
    movh        [r0 + r5    ], m2

    lea         r0,        [r6 + 8]
    add         r2,        8
    dec         r4
    jnz        .loop
    RET

INIT_XMM sse4
cglobal intra_pred_ang16_4, 3,7,8
    add         r2,        32
    lea         r3,        [ang_table + 16 * 16]
    mov         r4d,       2
    lea         r5,        [r1 * 3]                   ; r5 -> 3 * stride
    lea         r6,        [r0 + r1 * 4]              ; r6 -> 4 * stride
    mova        m7,        [pw_1024]

.loop:
    movu        m0,        [r2 + 1]
    palignr     m1,        m0, 1

    punpckhbw   m2,        m0, m1
    punpcklbw   m0,        m1
    palignr     m1,        m2, m0, 2
    mova        m5,        m1

    pmaddubsw   m4,        m0, [r3 + 5 * 16]          ; [21]
    pmulhrsw    m4,        m7
    pmaddubsw   m1,        [r3 - 6 * 16]              ; [10]
    pmulhrsw    m1,        m7
    packuswb    m4,        m1

    pmaddubsw   m5,        [r3 + 15 * 16]             ; [31]
    pmulhrsw    m5,        m7

    palignr     m6,        m2, m0, 4

    pmaddubsw   m6,        [r3 + 4 * 16]              ; [ 20]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    palignr     m1,        m2, m0, 6

    pmaddubsw   m6,        m1, [r3 - 7 * 16]          ; [ 9]
    pmulhrsw    m6,        m7

    pmaddubsw   m1,        [r3 + 14 * 16]             ; [30]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1

    palignr     m1,        m2, m0, 8

    pmaddubsw   m1,        [r3 + 3 * 16]              ; [19]
    pmulhrsw    m1,        m7

    palignr     m2,        m0, 10

    pmaddubsw   m3,        m2, [r3 - 8 * 16]          ; [8]
    pmulhrsw    m3,        m7
    packuswb    m1,        m3

    TRANSPOSE_STORE_8x8 0, 1, m4, m5, m6, m1

    pmaddubsw   m4,        m2, [r3 + 13 * 16]         ; [29]
    pmulhrsw    m4,        m7

    movu        m0,        [r2 + 6]
    palignr     m1,        m0, 1

    punpckhbw   m2,        m0, m1
    punpcklbw   m0,        m1
    palignr     m1,        m2, m0, 2

    pmaddubsw   m1,        [r3 +  2 * 16]             ; [18]
    pmulhrsw    m1,        m7
    packuswb    m4,        m1

    palignr     m5,        m2, m0, 4
    mova        m6,        m5

    pmaddubsw   m5,        [r3 - 9 * 16]              ; [07]
    pmulhrsw    m5,        m7

    pmaddubsw   m6,        [r3 + 12 * 16]             ; [28]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    palignr     m6,        m2, m0, 6

    pmaddubsw   m6,        [r3 +      16]             ; [17]
    pmulhrsw    m6,        m7

    palignr     m1,        m2, m0, 8
    palignr     m2,        m0, 10

    pmaddubsw   m3,        m1, [r3 - 10 * 16]         ; [06]
    pmulhrsw    m3,        m7
    packuswb    m6,        m3

    pmaddubsw   m1,        [r3 + 11 * 16]             ; [27]
    pmulhrsw    m1,        m7

    pmaddubsw   m2,        [r3]                       ; [16]
    pmulhrsw    m2,        m7
    packuswb    m1,        m2

    TRANSPOSE_STORE_8x8 1, 1, m4, m5, m6, m1

    lea         r0,        [r6 + r1 * 4]
    lea         r6,        [r6 + r1 * 8]
    add         r2,        8
    dec         r4
    jnz        .loop
    RET

INIT_XMM sse4
cglobal intra_pred_ang16_32, 3,7,8
    lea         r3,        [ang_table + 16 * 16]
    mov         r4d,       2
    lea         r5,        [r1 * 3]                   ; r5 -> 3 * stride
    mov         r6,        r0
    mova        m7,        [pw_1024]

.loop:
    movu        m0,        [r2 + 1]
    palignr     m1,        m0, 1

    punpckhbw   m2,        m0, m1
    punpcklbw   m0,        m1
    palignr     m1,        m2, m0, 2
    mova        m5,        m1


    pmaddubsw   m4,        m0, [r3 + 5 * 16]          ; [21]
    pmulhrsw    m4,        m7
    pmaddubsw   m1,        [r3 - 6 * 16]              ; [10]
    pmulhrsw    m1,        m7
    packuswb    m4,        m1

    pmaddubsw   m5,        [r3 + 15 * 16]             ; [31]
    pmulhrsw    m5,        m7

    palignr     m6,        m2, m0, 4

    pmaddubsw   m6,        [r3 + 4 * 16]              ; [ 20]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    palignr     m1,        m2, m0, 6

    pmaddubsw   m6,        m1, [r3 - 7 * 16]          ; [ 9]
    pmulhrsw    m6,        m7

    pmaddubsw   m1,        [r3 + 14 * 16]             ; [30]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1

    palignr     m1,        m2, m0, 8

    pmaddubsw   m1,        [r3 + 3 * 16]              ; [19]
    pmulhrsw    m1,        m7

    palignr     m2,        m0, 10

    pmaddubsw   m3,        m2, [r3 - 8 * 16]          ; [8]
    pmulhrsw    m3,        m7
    packuswb    m1,        m3

    TRANSPOSE_STORE_8x8 0, 0, m4, m5, m6, m1

    pmaddubsw   m4,        m2, [r3 + 13 * 16]         ; [29]
    pmulhrsw    m4,        m7

    movu        m0,        [r2 + 6]
    palignr     m1,        m0, 1

    punpckhbw   m2,        m0, m1
    punpcklbw   m0,        m1
    palignr     m1,        m2, m0, 2

    pmaddubsw   m1,        [r3 +  2 * 16]             ; [18]
    pmulhrsw    m1,        m7
    packuswb    m4,        m1

    palignr     m5,        m2, m0, 4
    mova        m6,        m5

    pmaddubsw   m5,        [r3 - 9 * 16]              ; [07]
    pmulhrsw    m5,        m7

    pmaddubsw   m6,        [r3 + 12 * 16]             ; [28]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    palignr     m6,        m2, m0, 6

    pmaddubsw   m6,        [r3 +      16]             ; [17]
    pmulhrsw    m6,        m7

    palignr     m1,        m2, m0, 8
    palignr     m2,        m0, 10

    pmaddubsw   m3,        m1, [r3 - 10 * 16]         ; [06]
    pmulhrsw    m3,        m7
    packuswb    m6,        m3

    pmaddubsw   m1,        [r3 + 11 * 16]             ; [27]
    pmulhrsw    m1,        m7

    pmaddubsw   m2,        [r3]                       ; [16]
    pmulhrsw    m2,        m7
    packuswb    m1,        m2

    TRANSPOSE_STORE_8x8 1, 0, m4, m5, m6, m1

    lea         r0,        [r6 + 8]
    add         r2,        8
    dec         r4
    jnz        .loop
    RET

INIT_XMM sse4
cglobal intra_pred_ang16_5, 3,7,8
    add         r2,        32
    lea         r3,        [ang_table + 16 * 16]
    mov         r4d,       2
    lea         r5,        [r1 * 3]                   ; r5 -> 3 * stride
    lea         r6,        [r0 + r1 * 4]              ; r6 -> 4 * stride
    mova        m7,        [pw_1024]

.loop:
    movu        m3,        [r2 + 1]                   ;[16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1]
    movu        m1,        [r2 + 2]                   ;[17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2]
    punpckhbw   m2,        m3, m1                     ;[17 16 16 15 15 14 14 13 13 12 12 11 11 10 10 9]
    punpcklbw   m3,        m1                         ;[9 8 8 7 7 6 6 5 5 4 4 3 3 2 2 1]

    palignr     m5,        m2, m3, 2

    pmaddubsw   m4,        m3, [r3 +      16]         ; [17]
    pmulhrsw    m4,        m7
    pmaddubsw   m1,        m5, [r3 - 14 * 16]         ; [2]
    pmulhrsw    m1,        m7
    packuswb    m4,        m1

    palignr     m6,        m2, m3, 4

    pmaddubsw   m5,        [r3 + 3 * 16]              ; [19]
    pmulhrsw    m5,        m7
    pmaddubsw   m1,        m6, [r3 - 12 * 16]         ; [4]
    pmulhrsw    m1,        m7
    packuswb    m5,        m1

    palignr     m1,        m2, m3, 6

    pmaddubsw   m6,        [r3 + 5 * 16]              ; [21]
    pmulhrsw    m6,        m7
    pmaddubsw   m0,        m1, [r3 - 10 * 16]         ; [6]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0

    palignr     m0,        m2, m3, 8

    pmaddubsw   m1,        [r3 + 7 * 16]              ; [23]
    pmulhrsw    m1,        m7
    pmaddubsw   m0,        [r3 - 8 * 16]              ; [8]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0

    TRANSPOSE_STORE_8x8 0, 1, m4, m5, m6, m1

    palignr     m4,        m2, m3, 8
    palignr     m5,        m2, m3, 10

    pmaddubsw   m4,        [r3 + 9 * 16]              ; [25]
    pmulhrsw    m4,        m7
    pmaddubsw   m1,        m5, [r3 - 6 * 16]          ; [10]
    pmulhrsw    m1,        m7
    packuswb    m4,        m1

    palignr     m6,        m2, m3, 12

    pmaddubsw   m5,        [r3 + 11 * 16]             ; [27]
    pmulhrsw    m5,        m7
    pmaddubsw   m1,        m6, [r3 - 4 * 16]          ; [12]
    pmulhrsw    m1,        m7
    packuswb    m5,        m1

    palignr     m1,        m2, m3, 14

    pmaddubsw   m6,        [r3 + 13 * 16]             ; [29]
    pmulhrsw    m6,        m7
    pmaddubsw   m0,        m1, [r3 - 2 * 16]          ; [14]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0

    pmaddubsw   m1,        [r3 + 15 * 16]             ; [31]
    pmulhrsw    m1,        m7
    pmaddubsw   m2,        [r3]                       ; [16]
    pmulhrsw    m2,        m7
    packuswb    m1,        m2

    TRANSPOSE_STORE_8x8 1, 1, m4, m5, m6, m1

    lea         r0,        [r6 + r1 * 4]
    lea         r6,        [r6 + r1 * 8]
    add         r2,        8
    dec         r4
    jnz        .loop
    RET

INIT_XMM sse4
cglobal intra_pred_ang16_31, 3,7,8
    lea         r3,        [ang_table + 16 * 16]
    mov         r4d,       2
    lea         r5,        [r1 * 3]                   ; r5 -> 3 * stride
    mov         r6,        r0
    mova        m7,        [pw_1024]

.loop:
    movu        m3,        [r2 + 1]                   ;[16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1]
    movu        m1,        [r2 + 2]                   ;[17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2]
    punpckhbw   m2,        m3, m1                     ;[17 16 16 15 15 14 14 13 13 12 12 11 11 10 10 9]
    punpcklbw   m3,        m1                         ;[9 8 8 7 7 6 6 5 5 4 4 3 3 2 2 1]

    palignr     m5,        m2, m3, 2

    pmaddubsw   m4,        m3, [r3 +      16]         ; [17]
    pmulhrsw    m4,        m7
    pmaddubsw   m1,        m5, [r3 - 14 * 16]         ; [2]
    pmulhrsw    m1,        m7
    packuswb    m4,        m1

    palignr     m6,        m2, m3, 4

    pmaddubsw   m5,        [r3 + 3 * 16]              ; [19]
    pmulhrsw    m5,        m7
    pmaddubsw   m1,        m6, [r3 - 12 * 16]         ; [4]
    pmulhrsw    m1,        m7
    packuswb    m5,        m1

    palignr     m1,        m2, m3, 6

    pmaddubsw   m6,        [r3 + 5 * 16]              ; [21]
    pmulhrsw    m6,        m7
    pmaddubsw   m0,        m1, [r3 - 10 * 16]         ; [6]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0

    palignr     m0,        m2, m3, 8

    pmaddubsw   m1,        [r3 + 7 * 16]              ; [23]
    pmulhrsw    m1,        m7
    pmaddubsw   m0,        [r3 - 8 * 16]              ; [8]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0

    TRANSPOSE_STORE_8x8 0, 0, m4, m5, m6, m1

    palignr     m4,        m2, m3, 8
    palignr     m5,        m2, m3, 10

    pmaddubsw   m4,        [r3 + 9 * 16]              ; [25]
    pmulhrsw    m4,        m7
    pmaddubsw   m1,        m5, [r3 - 6 * 16]          ; [10]
    pmulhrsw    m1,        m7
    packuswb    m4,        m1

    palignr     m6,        m2, m3, 12

    pmaddubsw   m5,        [r3 + 11 * 16]             ; [27]
    pmulhrsw    m5,        m7
    pmaddubsw   m1,        m6, [r3 - 4 * 16]          ; [12]
    pmulhrsw    m1,        m7
    packuswb    m5,        m1

    palignr     m1,        m2, m3, 14

    pmaddubsw   m6,        [r3 + 13 * 16]             ; [29]
    pmulhrsw    m6,        m7
    pmaddubsw   m0,        m1, [r3 - 2 * 16]          ; [14]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0

    pmaddubsw   m1,        [r3 + 15 * 16]             ; [31]
    pmulhrsw    m1,        m7
    pmaddubsw   m2,        [r3]                       ; [16]
    pmulhrsw    m2,        m7
    packuswb    m1,        m2

    TRANSPOSE_STORE_8x8 1, 0, m4, m5, m6, m1

    lea         r0,        [r6 + 8]
    add         r2,        8
    dec         r4
    jnz        .loop
    RET

INIT_XMM sse4
cglobal intra_pred_ang16_6, 3,7,8
    add         r2,        32
    lea         r3,        [ang_table + 16 * 16]
    mov         r4d,       2
    lea         r5,        [r1 * 3]                   ; r5 -> 3 * stride
    lea         r6,        [r0 + r1 * 4]              ; r6 -> 4 * stride
    mova        m7,        [pw_1024]

.loop:
    movu        m3,        [r2 + 1]                   ;[16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1]
    palignr     m1,        m3, 1                      ;[x 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2]
    punpckhbw   m2,        m3, m1                     ;[x 16 16 15 15 14 14 13 13 12 12 11 11 10 10 9]
    punpcklbw   m3,        m1                         ;[9 8 8 7 7 6 6 5 5 4 4 3 3 2 2 1]

    pmaddubsw   m4,        m3, [r3 - 3 * 16]          ; [13]
    pmulhrsw    m4,        m7
    pmaddubsw   m1,        m3, [r3 + 10 * 16]         ; [26]
    pmulhrsw    m1,        m7
    packuswb    m4,        m1

    palignr     m6,        m2, m3, 2

    pmaddubsw   m5,        m6, [r3 - 9 * 16]          ; [7]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        [r3 + 4 * 16]              ; [20]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    palignr     m1,        m2, m3, 4

    pmaddubsw   m6,        m1, [r3 - 15 * 16]         ; [1]
    pmulhrsw    m6,        m7
    pmaddubsw   m0,        m1, [r3 - 2 * 16]          ; [14]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0

    palignr     m0,        m2, m3, 6

    pmaddubsw   m1,        [r3 + 11 * 16]             ; [27]
    pmulhrsw    m1,        m7
    pmaddubsw   m0,        [r3 - 8 * 16]              ; [8]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0

    TRANSPOSE_STORE_8x8 0, 1, m4, m5, m6, m1

    palignr     m4,        m2, m3, 6
    palignr     m6,        m2, m3, 8

    pmaddubsw   m4,        [r3 +  5 * 16]             ; [21]
    pmulhrsw    m4,        m7
    pmaddubsw   m1,        m6, [r3 - 14 * 16]         ; [2]
    pmulhrsw    m1,        m7
    packuswb    m4,        m1

    pmaddubsw   m5,        m6, [r3 - 16]              ; [15]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        [r3 + 12 * 16]             ; [28]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    palignr     m0,        m2, m3, 10

    pmaddubsw   m6,        m0, [r3 - 7 * 16]          ; [9]
    pmulhrsw    m6,        m7
    pmaddubsw   m0,        [r3 + 6 * 16]              ; [22]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0

    palignr     m2,        m3, 12

    pmaddubsw   m1,        m2, [r3 - 13 * 16]         ; [3]
    pmulhrsw    m1,        m7
    pmaddubsw   m2,        [r3]                       ; [16]
    pmulhrsw    m2,        m7
    packuswb    m1,        m2

    TRANSPOSE_STORE_8x8 1, 1, m4, m5, m6, m1

    lea         r0,        [r6 + r1 * 4]
    lea         r6,        [r6 + r1 * 8]
    add         r2,        8
    dec         r4
    jnz        .loop
    RET

INIT_XMM sse4
cglobal intra_pred_ang16_30, 3,7,8
    lea         r3,        [ang_table + 16 * 16]
    mov         r4d,       2
    lea         r5,        [r1 * 3]                   ; r5 -> 3 * stride
    mov         r6,        r0
    mova        m7,        [pw_1024]

.loop:
    movu        m3,        [r2 + 1]                   ;[16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1]
    palignr     m1,        m3, 1                      ;[x 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2]
    punpckhbw   m2,        m3, m1                     ;[x 16 16 15 15 14 14 13 13 12 12 11 11 10 10 9]
    punpcklbw   m3,        m1                         ;[9 8 8 7 7 6 6 5 5 4 4 3 3 2 2 1]

    pmaddubsw   m4,        m3, [r3 - 3 * 16]          ; [13]
    pmulhrsw    m4,        m7
    pmaddubsw   m1,        m3, [r3 + 10 * 16]         ; [26]
    pmulhrsw    m1,        m7
    packuswb    m4,        m1

    palignr     m6,        m2, m3, 2

    pmaddubsw   m5,        m6, [r3 - 9 * 16]          ; [7]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        [r3 + 4 * 16]              ; [20]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    palignr     m1,        m2, m3, 4

    pmaddubsw   m6,        m1, [r3 - 15 * 16]         ; [1]
    pmulhrsw    m6,        m7
    pmaddubsw   m0,        m1, [r3 - 2 * 16]          ; [14]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0

    palignr     m0,        m2, m3, 6

    pmaddubsw   m1,        [r3 + 11 * 16]             ; [27]
    pmulhrsw    m1,        m7
    pmaddubsw   m0,        [r3 - 8 * 16]              ; [8]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0

    TRANSPOSE_STORE_8x8 0, 0, m4, m5, m6, m1

    palignr     m4,        m2, m3, 6
    palignr     m6,        m2, m3, 8

    pmaddubsw   m4,        [r3 +  5 * 16]             ; [21]
    pmulhrsw    m4,        m7
    pmaddubsw   m1,        m6, [r3 - 14 * 16]         ; [2]
    pmulhrsw    m1,        m7
    packuswb    m4,        m1

    pmaddubsw   m5,        m6, [r3 - 16]              ; [15]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        [r3 + 12 * 16]             ; [28]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    palignr     m0,        m2, m3, 10

    pmaddubsw   m6,        m0, [r3 - 7 * 16]          ; [9]
    pmulhrsw    m6,        m7
    pmaddubsw   m0,        [r3 + 6 * 16]              ; [22]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0

    palignr     m2,        m3, 12

    pmaddubsw   m1,        m2, [r3 - 13 * 16]         ; [3]
    pmulhrsw    m1,        m7
    pmaddubsw   m2,        [r3]                       ; [16]
    pmulhrsw    m2,        m7
    packuswb    m1,        m2

    TRANSPOSE_STORE_8x8 1, 0, m4, m5, m6, m1

    lea         r0,        [r6 + 8]
    add         r2,        8
    dec         r4
    jnz        .loop
    RET

INIT_XMM sse4
cglobal intra_pred_ang16_7, 3,7,8
    add         r2,        32
    lea         r3,        [ang_table + 16 * 16]
    mov         r4d,       2
    lea         r5,        [r1 * 3]            ; r5 -> 3 * stride
    lea         r6,        [r0 + r1 * 4]       ; r6 -> 4 * stride
    mova        m7,        [pw_1024]

.loop:
    movu        m3,        [r2 + 1]                   ;[16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1]
    palignr     m1,        m3, 1                      ;[x 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2]
    punpckhbw   m2,        m3, m1                     ;[x 16 16 15 15 14 14 13 13 12 12 11 11 10 10 9]
    punpcklbw   m3,        m1                         ;[9 8 8 7 7 6 6 5 5 4 4 3 3 2 2 1]

    pmaddubsw   m4,        m3, [r3 - 7 * 16]          ; [9]
    pmulhrsw    m4,        m7
    pmaddubsw   m0,        m3, [r3 + 2 * 16]          ; [18]
    pmulhrsw    m0,        m7
    packuswb    m4,        m0

    palignr     m1,        m2, m3, 2

    pmaddubsw   m5,        m3, [r3 + 11 * 16]         ; [27]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m1, [r3 - 12 * 16]         ; [4]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pmaddubsw   m6,        m1, [r3 - 3 * 16]          ; [13]
    pmulhrsw    m6,        m7
    pmaddubsw   m0,        m1, [r3 + 6 * 16]          ; [22]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0

    palignr     m0,        m2, m3, 4

    pmaddubsw   m1,        [r3 + 15 * 16]             ; [31]
    pmulhrsw    m1,        m7
    pmaddubsw   m0,        [r3 - 8 * 16]              ; [8]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0

    TRANSPOSE_STORE_8x8 0, 1, m4, m5, m6, m1

    palignr     m1,        m2, m3, 4

    pmaddubsw   m4,        m1, [r3 + 16]              ; [17]
    pmulhrsw    m4,        m7
    pmaddubsw   m1,        [r3 + 10 * 16]             ; [26]
    pmulhrsw    m1,        m7
    packuswb    m4,        m1

    palignr     m0,        m2, m3, 6

    pmaddubsw   m5,        m0, [r3 - 13 * 16]         ; [03]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m0, [r3 - 4 * 16]          ; [12]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pmaddubsw   m6,        m0, [r3 + 5 * 16]          ; [21]
    pmulhrsw    m6,        m7
    pmaddubsw   m0,        [r3 + 14 * 16]             ; [30]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0

    palignr     m2,        m3, 8

    pmaddubsw   m1,        m2, [r3 - 9 * 16]          ; [07]
    pmulhrsw    m1,        m7
    pmaddubsw   m2,        [r3]                       ; [16]
    pmulhrsw    m2,        m7
    packuswb    m1,        m2

    TRANSPOSE_STORE_8x8 1, 1, m4, m5, m6, m1

    lea         r0,        [r6 + r1 * 4]
    lea         r6,        [r6 + r1 * 8]
    add         r2,        8
    dec         r4
    jnz        .loop
    RET

INIT_XMM sse4
cglobal intra_pred_ang16_29, 3,7,8
    lea         r3,        [ang_table + 16 * 16]
    mov         r4d,       2
    lea         r5,        [r1 * 3]                   ; r5 -> 3 * stride
    mov         r6,        r0
    mova        m7,        [pw_1024]

.loop:
    movu        m3,        [r2 + 1]                   ;[16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1]
    palignr     m1,        m3, 1                      ;[x 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2]
    punpckhbw   m2,        m3, m1                     ;[x 16 16 15 15 14 14 13 13 12 12 11 11 10 10 9]
    punpcklbw   m3,        m1                         ;[9 8 8 7 7 6 6 5 5 4 4 3 3 2 2 1]

    pmaddubsw   m4,        m3, [r3 - 7 * 16]          ; [9]
    pmulhrsw    m4,        m7
    pmaddubsw   m0,        m3, [r3 + 2 * 16]          ; [18]
    pmulhrsw    m0,        m7
    packuswb    m4,        m0

    palignr     m1,        m2, m3, 2

    pmaddubsw   m5,        m3, [r3 + 11 * 16]         ; [27]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m1, [r3 - 12 * 16]         ; [4]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pmaddubsw   m6,        m1, [r3 - 3 * 16]          ; [13]
    pmulhrsw    m6,        m7
    pmaddubsw   m0,        m1, [r3 + 6 * 16]          ; [22]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0

    palignr     m0,        m2, m3, 4

    pmaddubsw   m1,        [r3 + 15 * 16]             ; [31]
    pmulhrsw    m1,        m7
    pmaddubsw   m0,        [r3 - 8 * 16]              ; [8]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0

    TRANSPOSE_STORE_8x8 0, 0, m4, m5, m6, m1

    palignr     m1,        m2, m3, 4

    pmaddubsw   m4,        m1, [r3 + 16]              ; [17]
    pmulhrsw    m4,        m7
    pmaddubsw   m1,        [r3 + 10 * 16]             ; [26]
    pmulhrsw    m1,        m7
    packuswb    m4,        m1

    palignr     m0,        m2, m3, 6

    pmaddubsw   m5,        m0, [r3 - 13 * 16]         ; [03]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m0, [r3 - 4 * 16]          ; [12]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pmaddubsw   m6,        m0, [r3 + 5 * 16]          ; [21]
    pmulhrsw    m6,        m7
    pmaddubsw   m0,        [r3 + 14 * 16]             ; [30]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0

    palignr     m2,        m3, 8

    pmaddubsw   m1,        m2, [r3 - 9 * 16]          ; [07]
    pmulhrsw    m1,        m7
    pmaddubsw   m2,        [r3]                       ; [16]
    pmulhrsw    m2,        m7
    packuswb    m1,        m2

    TRANSPOSE_STORE_8x8 1, 0, m4, m5, m6, m1

    lea         r0,        [r6 + 8]
    add         r2,        8
    dec         r4
    jnz        .loop
    RET

INIT_XMM sse4
cglobal intra_pred_ang16_8, 3,7,8
    add         r2,        32
    lea         r3,        [ang_table + 16 * 16]
    mov         r4d,       2
    lea         r5,        [r1 * 3]                   ; r5 -> 3 * stride
    lea         r6,        [r0 + r1 * 4]              ; r6 -> 4 * stride
    mova        m7,        [pw_1024]

.loop:
    movu        m1,        [r2 + 1]                   ;[16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1]
    palignr     m3,        m1, 1                      ;[x 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2]
    punpckhbw   m0,        m1, m3                     ;[x 16 16 15 15 14 14 13 13 12 12 11 11 10 10 9]
    punpcklbw   m1,        m3                         ;[9 8 8 7 7 6 6 5 5 4 4 3 3 2 2 1]

    pmaddubsw   m4,        m1, [r3 - 11 * 16]         ; [5]
    pmulhrsw    m4,        m7
    pmaddubsw   m2,        m1, [r3 - 6 * 16]          ; [10]
    pmulhrsw    m2,        m7
    packuswb    m4,        m2

    pmaddubsw   m5,        m1, [r3 - 1 * 16]          ; [15]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m1, [r3 + 4 * 16]          ; [20]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pmaddubsw   m6,        m1, [r3 + 9 * 16]          ; [25]
    pmulhrsw    m6,        m7
    pmaddubsw   m2,        m1, [r3 + 14 * 16]         ; [30]
    pmulhrsw    m2,        m7
    packuswb    m6,        m2

    palignr     m2,        m0, m1, 2
    palignr     m3,        m0, m1, 4

    pmaddubsw   m1,        m2, [r3 - 13 * 16]         ; [3]
    pmulhrsw    m1,        m7
    pmaddubsw   m0,        m2, [r3 - 8 * 16]          ; [8]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0

    TRANSPOSE_STORE_8x8 0, 1, m4, m5, m6, m1

    pmaddubsw   m4,        m2, [r3 - 3 * 16]          ; [13]
    pmulhrsw    m4,        m7
    pmaddubsw   m5,        m2, [r3 + 2 * 16]          ; [18]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    pmaddubsw   m5,        m2, [r3 + 7 * 16]          ; [23]
    pmulhrsw    m5,        m7
    pmaddubsw   m2,        [r3 + 12 * 16]             ; [28]
    pmulhrsw    m2,        m7
    packuswb    m5,        m2

    pmaddubsw   m6,        m3, [r3 - 15 * 16]         ; [01]
    pmulhrsw    m6,        m7
    pmaddubsw   m1,        m3, [r3 - 10 * 16]         ; [06]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1

    pmaddubsw   m1,        m3, [r3 - 5 * 16]          ; [11]
    pmulhrsw    m1,        m7
    pmaddubsw   m3,        [r3]                       ; [16]
    pmulhrsw    m3,        m7
    packuswb    m1,        m3

    TRANSPOSE_STORE_8x8 1, 1, m4, m5, m6, m1

    lea         r0,        [r6 + r1 * 4]
    lea         r6,        [r6 + r1 * 8]
    add         r2,        8
    dec         r4
    jnz        .loop
    RET

INIT_XMM sse4
cglobal intra_pred_ang16_28, 3,7,8
    lea         r3,        [ang_table + 16 * 16]
    mov         r4d,       2
    lea         r5,        [r1 * 3]                   ; r5 -> 3 * stride
    mov         r6,        r0
    mova        m7,        [pw_1024]

.loop:
    movu        m1,        [r2 + 1]                   ;[16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1]
    palignr     m3,        m1, 1                      ;[x 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2]
    punpckhbw   m0,        m1, m3                     ;[x 16 16 15 15 14 14 13 13 12 12 11 11 10 10 9]
    punpcklbw   m1,        m3                         ;[9 8 8 7 7 6 6 5 5 4 4 3 3 2 2 1]

    pmaddubsw   m4,        m1, [r3 - 11 * 16]         ; [5]
    pmulhrsw    m4,        m7
    pmaddubsw   m2,        m1, [r3 - 6 * 16]          ; [10]
    pmulhrsw    m2,        m7
    packuswb    m4,        m2

    pmaddubsw   m5,        m1, [r3 - 1 * 16]          ; [15]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m1, [r3 + 4 * 16]          ; [20]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pmaddubsw   m6,        m1, [r3 + 9 * 16]          ; [25]
    pmulhrsw    m6,        m7
    pmaddubsw   m2,        m1, [r3 + 14 * 16]         ; [30]
    pmulhrsw    m2,        m7
    packuswb    m6,        m2

    palignr     m2,        m0, m1, 2
    palignr     m3,        m0, m1, 4

    pmaddubsw   m1,        m2, [r3 - 13 * 16]         ; [3]
    pmulhrsw    m1,        m7
    pmaddubsw   m0,        m2, [r3 - 8 * 16]          ; [8]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0

    TRANSPOSE_STORE_8x8 0, 0, m4, m5, m6, m1

    pmaddubsw   m4,        m2, [r3 - 3 * 16]          ; [13]
    pmulhrsw    m4,        m7
    pmaddubsw   m5,        m2, [r3 + 2 * 16]          ; [18]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    pmaddubsw   m5,        m2, [r3 + 7 * 16]          ; [23]
    pmulhrsw    m5,        m7
    pmaddubsw   m2,        [r3 + 12 * 16]             ; [28]
    pmulhrsw    m2,        m7
    packuswb    m5,        m2

    pmaddubsw   m6,        m3, [r3 - 15 * 16]         ; [01]
    pmulhrsw    m6,        m7
    pmaddubsw   m1,        m3, [r3 - 10 * 16]         ; [06]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1

    pmaddubsw   m1,        m3, [r3 - 5 * 16]          ; [11]
    pmulhrsw    m1,        m7
    pmaddubsw   m3,        [r3]                       ; [16]
    pmulhrsw    m3,        m7
    packuswb    m1,        m3

    TRANSPOSE_STORE_8x8 1, 0, m4, m5, m6, m1

    lea         r0,        [r6 + 8]
    add         r2,        8
    dec         r4
    jnz        .loop
    RET

INIT_XMM sse4
cglobal intra_pred_ang16_9, 3,7,8
    add         r2,        32
    lea         r3,        [ang_table + 16 * 16]
    mov         r4d,       2
    lea         r5,        [r1 * 3]                   ; r5 -> 3 * stride
    lea         r6,        [r0 + r1 * 4]              ; r6 -> 4 * stride
    mova        m7,        [pw_1024]

.loop:
    movu        m2,        [r2 + 1]                   ;[16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1]
    palignr     m3,        m2, 1                      ;[x 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2]
    punpcklbw   m2,        m3                         ;[9 8 8 7 7 6 6 5 5 4 4 3 3 2 2 1]

    pmaddubsw   m4,        m2, [r3 - 14 * 16]         ; [2]
    pmulhrsw    m4,        m7
    pmaddubsw   m0,        m2, [r3 - 12 * 16]         ; [4]
    pmulhrsw    m0,        m7
    packuswb    m4,        m0

    pmaddubsw   m5,        m2, [r3 - 10 * 16]         ; [6]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m2, [r3 - 8 * 16]          ; [8]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pmaddubsw   m6,        m2, [r3 - 6 * 16]          ; [10]
    pmulhrsw    m6,        m7
    pmaddubsw   m0,        m2, [r3 - 4 * 16]          ; [12]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0

    pmaddubsw   m1,        m2, [r3 - 2 * 16]          ; [14]
    pmulhrsw    m1,        m7
    pmaddubsw   m0,        m2, [r3]                   ; [16]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0

    TRANSPOSE_STORE_8x8 0, 1, m4, m5, m6, m1

    pmaddubsw   m4,        m2, [r3 + 2 * 16]          ; [18]
    pmulhrsw    m4,        m7
    pmaddubsw   m5,        m2, [r3 + 4 * 16]          ; [20]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    pmaddubsw   m5,        m2, [r3 + 6 * 16]          ; [22]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m2, [r3 + 8 * 16]          ; [24]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pmaddubsw   m6,        m2, [r3 + 10 * 16]         ; [26]
    pmulhrsw    m6,        m7
    pmaddubsw   m1,        m2, [r3 + 12 * 16]         ; [28]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1

    pmaddubsw   m1,        m2, [r3 + 14 * 16]         ; [30]
    pmulhrsw    m1,        m7
    packuswb    m1,        m1

    punpcklqdq  m1,        m3                         ; [00]

    TRANSPOSE_STORE_8x8 1, 1, m4, m5, m6, m1

    lea         r0,        [r6 + r1 * 4]
    lea         r6,        [r6 + r1 * 8]
    add         r2,        8
    dec         r4
    jnz        .loop
    RET

INIT_XMM sse4
cglobal intra_pred_ang16_27, 3,7,8
    lea         r3,        [ang_table + 16 * 16]
    mov         r4d,       2
    lea         r5,        [r1 * 3]                   ; r5 -> 3 * stride
    mov         r6,        r0
    mova        m7,        [pw_1024]

.loop:
    movu        m3,        [r2 + 1]                   ;[16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1]
    palignr     m2,        m3, 1                      ;[x 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2]
    punpcklbw   m3,        m2                         ;[9 8 8 7 7 6 6 5 5 4 4 3 3 2 2 1]

    pmaddubsw   m4,        m3, [r3 - 14 * 16]         ; [2]
    pmulhrsw    m4,        m7
    pmaddubsw   m0,        m3, [r3 - 12 * 16]         ; [4]
    pmulhrsw    m0,        m7
    packuswb    m4,        m0

    pmaddubsw   m5,        m3, [r3 - 10 * 16]         ; [6]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m3, [r3 - 8 * 16]          ; [8]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pmaddubsw   m6,        m3, [r3 - 6 * 16]          ; [10]
    pmulhrsw    m6,        m7
    pmaddubsw   m0,        m3, [r3 - 4 * 16]          ; [12]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0

    pmaddubsw   m1,        m3, [r3 - 2 * 16]          ; [14]
    pmulhrsw    m1,        m7
    pmaddubsw   m0,        m3, [r3]                   ; [16]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0

    TRANSPOSE_STORE_8x8 0, 0, m4, m5, m6, m1

    pmaddubsw   m4,        m3, [r3 + 2 * 16]          ; [18]
    pmulhrsw    m4,        m7
    pmaddubsw   m5,        m3, [r3 + 4 * 16]          ; [20]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    pmaddubsw   m5,        m3, [r3 + 6 * 16]          ; [22]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m3, [r3 + 8 * 16]          ; [24]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pmaddubsw   m6,        m3, [r3 + 10 * 16]         ; [26]
    pmulhrsw    m6,        m7
    pmaddubsw   m1,        m3, [r3 + 12 * 16]         ; [28]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1

    pmaddubsw   m1,        m3, [r3 + 14 * 16]         ; [30]
    pmulhrsw    m1,        m7
    packuswb    m1,        m1

    movh        [r0         ], m4
    movhps      [r0 + r1    ], m4
    movh        [r0 + r1 * 2], m5
    movhps      [r0 + r5    ], m5
    lea         r0, [r0 + r1 * 4]
    movh        [r0         ], m6
    movhps      [r0 + r1    ], m6
    movh        [r0 + r1 * 2], m1
    movh        [r0 + r5    ], m2

    lea         r0,        [r6 + 8]
    add         r2,        8
    dec         r4
    jnz        .loop
    RET

INIT_XMM sse4
cglobal intra_pred_ang16_10, 5,6,8
    lea         r5,        [r1 * 3]
    pxor        m7,        m7

    movu        m0,        [r2 + 1 + 32]
    palignr     m1,        m0, 1
    pshufb      m1,        m7
    palignr     m2,        m0, 2
    pshufb      m2,        m7
    palignr     m3,        m0, 3
    pshufb      m3,        m7
    palignr     m4,        m0, 4
    pshufb      m4,        m7
    palignr     m5,        m0, 5
    pshufb      m5,        m7
    palignr     m6,        m0, 6
    pshufb      m6,        m7

    movu        [r0 + r1],      m1
    movu        [r0 + r1 * 2],  m2
    movu        [r0 + r5],      m3
    lea         r3,             [r0 + r1 * 4]
    movu        [r3],           m4
    movu        [r3 + r1],      m5
    movu        [r3 + r1 * 2],  m6

    palignr     m1,        m0, 7
    pshufb      m1,        m7
    movhlps     m2,        m0
    pshufb      m2,        m7
    palignr     m3,        m0, 9
    pshufb      m3,        m7
    palignr     m4,        m0, 10
    pshufb      m4,        m7
    palignr     m5,        m0, 11
    pshufb      m5,        m7
    palignr     m6,        m0, 12
    pshufb      m6,        m7

    movu        [r3 + r5],      m1
    lea         r3,             [r3 + r1 * 4]
    movu        [r3],           m2
    movu        [r3 + r1],      m3
    movu        [r3 + r1 * 2],  m4
    movu        [r3 + r5],      m5
    lea         r3,             [r3 + r1 * 4]
    movu        [r3],           m6

    palignr     m1,        m0, 13
    pshufb      m1,        m7
    palignr     m2,        m0, 14
    pshufb      m2,        m7
    palignr     m3,        m0, 15
    pshufb      m3,        m7
    pshufb      m0,        m7

    movu        [r3 + r1],      m1
    movu        [r3 + r1 * 2],  m2
    movu        [r3 + r5],      m3

; filter
    cmp         r4w, byte 0
    jz         .quit
    pmovzxbw    m0,        m0
    mova        m1,        m0
    movu        m2,        [r2]
    movu        m3,        [r2 + 1]

    pshufb      m2,        m7
    pmovzxbw    m2,        m2
    movhlps     m4,        m3
    pmovzxbw    m3,        m3
    pmovzxbw    m4,        m4
    psubw       m3,        m2
    psubw       m4,        m2
    psraw       m3,        1
    psraw       m4,        1
    paddw       m0,        m3
    paddw       m1,        m4
    packuswb    m0,        m1
.quit:
    movu        [r0],      m0
    RET

INIT_XMM sse4
%if ARCH_X86_64 == 1
cglobal intra_pred_ang16_26, 3,8,5
    mov     r7, r4mp
    %define bfilter r7w
%else
cglobal intra_pred_ang16_26, 5,7,5,0-4
    %define bfilter dword[rsp]
    mov     bfilter, r4
%endif
    movu        m0,             [r2 + 1]

    lea         r4,             [r1 * 3]
    lea         r3,             [r0 + r1 * 4]
    lea         r5,             [r3 + r1 * 4]
    lea         r6,             [r5 + r1 * 4]

    movu        [r0],           m0
    movu        [r0 + r1],      m0
    movu        [r0 + r1 * 2],  m0
    movu        [r0 + r4],      m0
    movu        [r3],           m0
    movu        [r3 + r1],      m0
    movu        [r3 + r1 * 2],  m0
    movu        [r3 + r4],      m0
    movu        [r5],           m0
    movu        [r5 + r1],      m0
    movu        [r5 + r1 * 2],  m0
    movu        [r5 + r4],      m0

    movu        [r6],           m0
    movu        [r6 + r1],      m0
    movu        [r6 + r1 * 2],  m0
    movu        [r6 + r4],      m0

; filter
    cmp         bfilter, byte 0
    jz         .quit

    pxor        m4,        m4
    pshufb      m0,        m4
    pmovzxbw    m0,        m0
    mova        m1,        m0
    movu        m2,        [r2 + 32]
    pinsrb      m2,        [r2], 0
    movu        m3,        [r2 + 1 + 32]

    pshufb      m2,        m4
    pmovzxbw    m2,        m2
    movhlps     m4,        m3
    pmovzxbw    m3,        m3
    pmovzxbw    m4,        m4
    psubw       m3,        m2
    psubw       m4,        m2
    psraw       m3,        1
    psraw       m4,        1
    paddw       m0,        m3
    paddw       m1,        m4
    packuswb    m0,        m1

    pextrb      [r0],           m0, 0
    pextrb      [r0 + r1],      m0, 1
    pextrb      [r0 + r1 * 2],  m0, 2
    pextrb      [r0 + r4],      m0, 3
    pextrb      [r3],           m0, 4
    pextrb      [r3 + r1],      m0, 5
    pextrb      [r3 + r1 * 2],  m0, 6
    pextrb      [r3 + r4],      m0, 7
    pextrb      [r5],           m0, 8
    pextrb      [r5 + r1],      m0, 9
    pextrb      [r5 + r1 * 2],  m0, 10
    pextrb      [r5 + r4],      m0, 11
    pextrb      [r6],           m0, 12
    pextrb      [r6 + r1],      m0, 13
    pextrb      [r6 + r1 * 2],  m0, 14
    pextrb      [r6 + r4],      m0, 15
.quit:
    RET

INIT_XMM sse4
cglobal intra_pred_ang16_11, 3,7,8
    lea         r3,        [ang_table + 16 * 16]
    lea         r5,        [r1 * 3]                   ; r5 -> 3 * stride
    lea         r6,        [r0 + r1 * 4]              ; r6 -> 4 * stride
    mova        m7,        [pw_1024]

    movu        m3,        [r2 + 32]              ;[15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0]
    pinsrb      m3,        [r2], 0
    mova        m2,        m3
    palignr     m1,        m3, 1                  ;[15 14 13 12 11 10 9 8 7 6 5 4 3 2 1]
    punpcklbw   m3,        m1                     ;[8 7 7 6 6 5 5 4 4 3 3 2 2 1 1 0]

    pmaddubsw   m4,        m3, [r3 + 14 * 16]         ; [30]
    pmulhrsw    m4,        m7
    pmaddubsw   m0,        m3, [r3 + 12 * 16]         ; [28]
    pmulhrsw    m0,        m7
    packuswb    m4,        m0

    pmaddubsw   m5,        m3, [r3 + 10 * 16]         ; [26]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m3, [r3 + 8 * 16]          ; [24]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pmaddubsw   m6,        m3, [r3 + 6 * 16]          ; [22]
    pmulhrsw    m6,        m7
    pmaddubsw   m0,        m3, [r3 + 4 * 16]          ; [20]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0

    pmaddubsw   m1,        m3, [r3 + 2 * 16]          ; [18]
    pmulhrsw    m1,        m7
    pmaddubsw   m0,        m3, [r3]                   ; [16]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0

    TRANSPOSE_STORE_8x8 0, 1, m4, m5, m6, m1

    pmaddubsw   m4,        m3, [r3 - 2 * 16]          ; [14]
    pmulhrsw    m4,        m7
    pmaddubsw   m5,        m3, [r3 - 4 * 16]          ; [12]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    pmaddubsw   m5,        m3, [r3 - 6 * 16]          ; [10]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m3, [r3 - 8 * 16]          ; [08]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pmaddubsw   m6,        m3, [r3 - 10 * 16]         ; [06]
    pmulhrsw    m6,        m7
    pmaddubsw   m1,        m3, [r3 - 12 * 16]         ; [04]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1

    pmaddubsw   m1,        m3, [r3 - 14 * 16]         ; [02]
    pmulhrsw    m1,        m7
    packuswb    m1,        m1
    punpcklqdq  m1,        m2                         ;[00]

    TRANSPOSE_STORE_8x8 1, 1, m4, m5, m6, m1

    lea         r0,        [r6 + r1 * 4]
    lea         r6,        [r6 + r1 * 8]

    movu        m3,        [r2 + 40]              ;[15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0]
    mova        m2,        m3
    palignr     m1,        m3, 1                  ;[15 14 13 12 11 10 9 8 7 6 5 4 3 2 1]
    punpcklbw   m3,        m1                     ;[8 7 7 6 6 5 5 4 4 3 3 2 2 1 1 0]

    pmaddubsw   m4,        m3, [r3 + 14 * 16]         ; [30]
    pmulhrsw    m4,        m7
    pmaddubsw   m0,        m3, [r3 + 12 * 16]         ; [28]
    pmulhrsw    m0,        m7
    packuswb    m4,        m0

    pmaddubsw   m5,        m3, [r3 + 10 * 16]         ; [26]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m3, [r3 + 8 * 16]          ; [24]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pmaddubsw   m6,        m3, [r3 + 6 * 16]          ; [22]
    pmulhrsw    m6,        m7
    pmaddubsw   m0,        m3, [r3 + 4 * 16]          ; [20]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0

    pmaddubsw   m1,        m3, [r3 + 2 * 16]          ; [18]
    pmulhrsw    m1,        m7
    pmaddubsw   m0,        m3, [r3]                   ; [16]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0

    TRANSPOSE_STORE_8x8 0, 1, m4, m5, m6, m1

    pmaddubsw   m4,        m3, [r3 - 2 * 16]          ; [14]
    pmulhrsw    m4,        m7
    pmaddubsw   m5,        m3, [r3 - 4 * 16]          ; [12]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    pmaddubsw   m5,        m3, [r3 - 6 * 16]          ; [10]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m3, [r3 - 8 * 16]          ; [08]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pmaddubsw   m6,        m3, [r3 - 10 * 16]         ; [06]
    pmulhrsw    m6,        m7
    pmaddubsw   m1,        m3, [r3 - 12 * 16]         ; [04]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1

    pmaddubsw   m1,        m3, [r3 - 14 * 16]         ; [02]
    pmulhrsw    m1,        m7
    packuswb    m1,        m1
    punpcklqdq  m1,        m2                         ;[00]

    TRANSPOSE_STORE_8x8 1, 1, m4, m5, m6, m1
    RET

INIT_XMM sse4
cglobal intra_pred_ang16_25, 3,7,8
    lea         r3,        [ang_table + 16 * 16]
    mov         r4d,       2
    lea         r5,        [r1 * 3]                   ; r5 -> 3 * stride
    mov         r6,        r0
    mova        m7,        [pw_1024]

.loop:
    movu        m3,        [r2]                   ;[15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0]
    mova        m2,        m3
    palignr     m1,        m3, 1                  ;[15 14 13 12 11 10 9 8 7 6 5 4 3 2 1]
    punpcklbw   m3,        m1                     ;[8 7 7 6 6 5 5 4 4 3 3 2 2 1 1 0]

    pmaddubsw   m4,        m3, [r3 + 14 * 16]         ; [30]
    pmulhrsw    m4,        m7
    pmaddubsw   m0,        m3, [r3 + 12 * 16]         ; [28]
    pmulhrsw    m0,        m7
    packuswb    m4,        m0

    pmaddubsw   m5,        m3, [r3 + 10 * 16]         ; [26]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m3, [r3 + 8 * 16]          ; [24]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pmaddubsw   m6,        m3, [r3 + 6 * 16]          ; [22]
    pmulhrsw    m6,        m7
    pmaddubsw   m0,        m3, [r3 + 4 * 16]          ; [20]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0

    pmaddubsw   m1,        m3, [r3 + 2 * 16]          ; [18]
    pmulhrsw    m1,        m7
    pmaddubsw   m0,        m3, [r3]                   ; [16]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0

    TRANSPOSE_STORE_8x8 0, 0, m4, m5, m6, m1

    pmaddubsw   m4,        m3, [r3 - 2 * 16]          ; [14]
    pmulhrsw    m4,        m7
    pmaddubsw   m5,        m3, [r3 - 4 * 16]          ; [12]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    pmaddubsw   m5,        m3, [r3 - 6 * 16]          ; [10]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m3, [r3 - 8 * 16]          ; [08]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pmaddubsw   m6,        m3, [r3 - 10 * 16]         ; [06]
    pmulhrsw    m6,        m7
    pmaddubsw   m1,        m3, [r3 - 12 * 16]         ; [04]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1

    pmaddubsw   m1,        m3, [r3 - 14 * 16]         ; [02]
    pmulhrsw    m1,        m7
    packuswb    m1,        m1

    movh        [r0         ], m4
    movhps      [r0 + r1    ], m4
    movh        [r0 + r1 * 2], m5
    movhps      [r0 + r5    ], m5
    lea         r0, [r0 + r1 * 4]
    movh        [r0         ], m6
    movhps      [r0 + r1    ], m6
    movh        [r0 + r1 * 2], m1
    movh        [r0 + r5    ], m2

    lea         r0,        [r6 + 8]
    add         r2,        8
    dec         r4
    jnz        .loop
    RET

INIT_XMM sse4
cglobal intra_pred_ang16_12, 4,7,8
    lea         r4,        [ang_table + 16 * 16]
    lea         r5,        [r1 * 3]                   ; r5 -> 3 * stride
    lea         r6,        [r0 + r1 * 4]              ; r6 -> 4 * stride
    mova        m7,        [pw_1024]

    movu        m3,        [r2 + 32]                  ; [15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0]
    pinsrb      m3,        [r2], 0
    punpckhbw   m0,        m3, m3                     ; [15 15 14 14 13 13 12 12 11 11 10 10 9 9 8 8]
    punpcklbw   m3,        m3                         ; [7 7 6 6 5 5 4 4 3 3 2 2 1 1 0 0]
    movu        m2,        [r2]
    pshufb      m2,        [c_mode16_12]

    palignr     m0,        m3, 1                      ; [8 7 7 6 6 5 5 4 4 3 3 2 2 1 1 0]

    pmaddubsw   m4,        m0, [r4 + 11 * 16]         ; [27]
    pmulhrsw    m4,        m7
    pmaddubsw   m1,        m0, [r4 + 6 * 16]          ; [22]
    pmulhrsw    m1,        m7
    packuswb    m4,        m1

    pmaddubsw   m5,        m0, [r4 + 1 * 16]          ; [17]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m0, [r4 - 4 * 16]          ; [12]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pmaddubsw   m6,        m0, [r4 - 9 * 16]          ; [7]
    pmulhrsw    m6,        m7
    pmaddubsw   m0,        [r4 - 14 * 16]             ; [2]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0

    palignr     m3,        m2, 15

    pmaddubsw   m1,        m3, [r4 + 13 * 16]         ; [29]
    pmulhrsw    m1,        m7
    pmaddubsw   m0,        m3, [r4 + 8 * 16]          ; [24]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0

    TRANSPOSE_STORE_8x8 0, 1, m4, m5, m6, m1

    pmaddubsw   m4,        m3, [r4 + 3 * 16]          ; [19]
    pmulhrsw    m4,        m7
    pmaddubsw   m5,        m3, [r4 - 2 * 16]          ; [14]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    pmaddubsw   m5,        m3, [r4 - 7 * 16]          ; [09]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m3, [r4 - 12 * 16]         ; [04]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 + 15 * 16]         ; [31]
    pmulhrsw    m6,        m7
    pmaddubsw   m1,        m3, [r4 + 10 * 16]         ; [26]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1

    pmaddubsw   m1,        m3, [r4 + 5 * 16]          ; [21]
    pmulhrsw    m1,        m7
    pmaddubsw   m3,        [r4]                       ; [16]
    pmulhrsw    m3,        m7
    packuswb    m1,        m3

    TRANSPOSE_STORE_8x8 1, 1, m4, m5, m6, m1

    lea         r0,        [r6 + r1 * 4]
    lea         r6,        [r6 + r1 * 8]

    movu        m1,        [r2 + 1 + 32]              ; [16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1]
    pslldq      m3,        m1, 1                      ; [15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 x]
    punpckhbw   m3,        m1                         ; [16 15 15 14 14 13 13 12 12 11 11 10 10 9 9 8]
    movlhps     m2,        m1                         ; [8 7 6 5 4 3 2 1 x x x x x x x]

    pmaddubsw   m4,        m3, [r4 + 11 * 16]         ; [27]
    pmulhrsw    m4,        m7
    pmaddubsw   m5,        m3, [r4 + 6 * 16]          ; [22]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    pmaddubsw   m5,        m3, [r4 + 1 * 16]          ; [17]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m3, [r4 - 4 * 16]          ; [12]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pmaddubsw   m6,        m3, [r4 - 9 * 16]          ; [7]
    pmulhrsw    m6,        m7
    pmaddubsw   m0,        m3, [r4 - 14 * 16]         ; [2]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0

    palignr     m3,        m2, 14

    pmaddubsw   m1,        m3, [r4 + 13 * 16]         ; [29]
    pmulhrsw    m1,        m7
    pmaddubsw   m0,        m3, [r4 + 8 * 16]          ; [24]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0

    TRANSPOSE_STORE_8x8 0, 1, m4, m5, m6, m1

    pmaddubsw   m4,        m3, [r4 + 3 * 16]          ; [19]
    pmulhrsw    m4,        m7
    pmaddubsw   m5,        m3, [r4 - 2 * 16]          ; [14]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    pmaddubsw   m5,        m3, [r4 - 7 * 16]          ; [09]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m3, [r4 - 12 * 16]         ; [04]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 + 15 * 16]         ; [31]
    pmulhrsw    m6,        m7
    pmaddubsw   m1,        m3, [r4 + 10 * 16]         ; [26]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1

    pmaddubsw   m1,        m3, [r4 + 5 * 16]          ; [21]
    pmulhrsw    m1,        m7
    pmaddubsw   m3,        [r4]                       ; [16]
    pmulhrsw    m3,        m7
    packuswb    m1,        m3

    TRANSPOSE_STORE_8x8 1, 1, m4, m5, m6, m1
    RET

INIT_XMM sse4
cglobal intra_pred_ang16_24, 4,7,8
    lea         r4,        [ang_table + 16 * 16]
    lea         r5,        [r1 * 3]                   ; r5 -> 3 * stride
    mov         r6,        r0
    mova        m7,        [pw_1024]

    movu        m3,        [r2]                       ; [15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0]
    punpckhbw   m0,        m3, m3                     ; [15 15 14 14 13 13 12 12 11 11 10 10 9 9 8 8]
    punpcklbw   m3,        m3                         ; [7 7 6 6 5 5 4 4 3 3 2 2 1 1 0 0]
    movu        m2,        [r2 + 32]
    pshufb      m2,        [c_mode16_12]

    palignr     m0,        m3, 1                      ; [8 7 7 6 6 5 5 4 4 3 3 2 2 1 1 0]

    pmaddubsw   m4,        m0, [r4 + 11 * 16]         ; [27]
    pmulhrsw    m4,        m7
    pmaddubsw   m1,        m0, [r4 + 6 * 16]          ; [22]
    pmulhrsw    m1,        m7
    packuswb    m4,        m1

    pmaddubsw   m5,        m0, [r4 + 1 * 16]          ; [17]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m0, [r4 - 4 * 16]          ; [12]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pmaddubsw   m6,        m0, [r4 - 9 * 16]          ; [7]
    pmulhrsw    m6,        m7
    pmaddubsw   m0,        [r4 - 14 * 16]             ; [2]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0

    palignr     m3,        m2, 15

    pmaddubsw   m1,        m3, [r4 + 13 * 16]         ; [29]
    pmulhrsw    m1,        m7
    pmaddubsw   m0,        m3, [r4 + 8 * 16]          ; [24]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0

    TRANSPOSE_STORE_8x8 0, 0, m4, m5, m6, m1

    pmaddubsw   m4,        m3, [r4 + 3 * 16]          ; [19]
    pmulhrsw    m4,        m7
    pmaddubsw   m5,        m3, [r4 - 2 * 16]          ; [14]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    pmaddubsw   m5,        m3, [r4 - 7 * 16]          ; [09]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m3, [r4 - 12 * 16]         ; [04]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 + 15 * 16]         ; [31]
    pmulhrsw    m6,        m7
    pmaddubsw   m1,        m3, [r4 + 10 * 16]         ; [26]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1

    pmaddubsw   m1,        m3, [r4 + 5 * 16]          ; [21]
    pmulhrsw    m1,        m7
    pmaddubsw   m3,        [r4]                       ; [16]
    pmulhrsw    m3,        m7
    packuswb    m1,        m3

    TRANSPOSE_STORE_8x8 1, 0, m4, m5, m6, m1

    lea         r0,        [r6 + 8]

    movu        m1,        [r2 + 1]                   ; [16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1]
    pslldq      m3,        m1, 1                      ; [15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 x]
    punpckhbw   m3,        m1                         ; [16 15 15 14 14 13 13 12 12 11 11 10 10 9 9 8]
    movlhps     m2,        m1                         ; [8 7 6 5 4 3 2 1 x x x x x x x]

    pmaddubsw   m4,        m3, [r4 + 11 * 16]         ; [27]
    pmulhrsw    m4,        m7
    pmaddubsw   m5,        m3, [r4 + 6 * 16]          ; [22]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    pmaddubsw   m5,        m3, [r4 + 1 * 16]          ; [17]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m3, [r4 - 4 * 16]          ; [12]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pmaddubsw   m6,        m3, [r4 - 9 * 16]          ; [7]
    pmulhrsw    m6,        m7
    pmaddubsw   m0,        m3, [r4 - 14 * 16]         ; [2]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0

    palignr     m3,        m2, 14

    pmaddubsw   m1,        m3, [r4 + 13 * 16]         ; [29]
    pmulhrsw    m1,        m7
    pmaddubsw   m0,        m3, [r4 + 8 * 16]          ; [24]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0

    TRANSPOSE_STORE_8x8 0, 0, m4, m5, m6, m1

    pmaddubsw   m4,        m3, [r4 + 3 * 16]          ; [19]
    pmulhrsw    m4,        m7
    pmaddubsw   m5,        m3, [r4 - 2 * 16]          ; [14]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    pmaddubsw   m5,        m3, [r4 - 7 * 16]          ; [09]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m3, [r4 - 12 * 16]         ; [04]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 + 15 * 16]         ; [31]
    pmulhrsw    m6,        m7
    pmaddubsw   m1,        m3, [r4 + 10 * 16]         ; [26]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1

    pmaddubsw   m1,        m3, [r4 + 5 * 16]          ; [21]
    pmulhrsw    m1,        m7
    pmaddubsw   m3,        [r4]                       ; [16]
    pmulhrsw    m3,        m7
    packuswb    m1,        m3

    TRANSPOSE_STORE_8x8 1, 0, m4, m5, m6, m1
    RET

INIT_XMM sse4
cglobal intra_pred_ang16_13, 4,7,8
    lea         r4,        [ang_table + 16 * 16]
    lea         r5,        [r1 * 3]                   ; r5 -> 3 * stride
    lea         r6,        [r0 + r1 * 4]              ; r6 -> 4 * stride
    mova        m7,        [pw_1024]

    movu        m3,        [r2 + 32]                  ; [15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0]
    pinsrb      m3,        [r2], 0
    punpckhbw   m5,        m3, m3                     ; [15 15 14 14 13 13 12 12 11 11 10 10 9 9 8 8]
    punpcklbw   m3,        m3                         ; [7 7 6 6 5 5 4 4 3 3 2 2 1 1 0 0]
    movu        m2,        [r2]
    pshufb      m2,        [c_mode16_13]

    palignr     m5,        m3, 1                      ; [8 7 7 6 6 5 5 4 4 3 3 2 2 1 1 0]

    pmaddubsw   m4,        m5, [r4 + 7 * 16]          ; [23]
    pmulhrsw    m4,        m7
    pmaddubsw   m0,        m5, [r4 - 2 * 16]          ; [14]
    pmulhrsw    m0,        m7
    packuswb    m4,        m0

    pmaddubsw   m5,        [r4 - 11 * 16]             ; [05]
    pmulhrsw    m5,        m7

    palignr     m3,        m2, 15

    pmaddubsw   m6,        m3, [r4 + 12 * 16]         ; [28]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pmaddubsw   m6,        m3, [r4 + 3 * 16]          ; [19]
    pmulhrsw    m6,        m7
    pmaddubsw   m0,        m3, [r4 - 6 * 16]          ; [10]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0

    pmaddubsw   m1,        m3, [r4 - 15 * 16]         ; [01]
    pmulhrsw    m1,        m7

    palignr     m3,       m2, 14

    pmaddubsw   m0,        m3, [r4 + 8 * 16]          ; [24]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0

    TRANSPOSE_STORE_8x8 0, 1, m4, m5, m6, m1

    pmaddubsw   m4,        m3, [r4 - 16]              ; [15]
    pmulhrsw    m4,        m7
    pmaddubsw   m5,        m3, [r4 - 10 * 16]         ; [06]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m5,        m3, [r4 + 13 * 16]         ; [29]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m3, [r4 + 4  * 16]         ; [20]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pmaddubsw   m6,        m3, [r4 - 5 * 16]          ; [11]
    pmulhrsw    m6,        m7
    pmaddubsw   m1,        m3, [r4 - 14 * 16]         ; [02]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m1,        m3, [r4 + 9 * 16]          ; [25]
    pmulhrsw    m1,        m7
    pmaddubsw   m3,        [r4]                       ; [16]
    pmulhrsw    m3,        m7
    packuswb    m1,        m3

    TRANSPOSE_STORE_8x8 1, 1, m4, m5, m6, m1

    lea         r0,        [r6 + r1 * 4]
    lea         r6,        [r6 + r1 * 8]

    movu        m1,        [r2 + 1 + 32]              ; [16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1]
    pslldq      m3,        m1, 1                      ; [15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 x]
    punpckhbw   m3,        m1                         ; [16 15 15 14 14 13 13 12 12 11 11 10 10 9 9 8]
    movlhps     m2,        m1                         ; [8 7 6 5 4 3 2 1 x x x x x x x]

    pmaddubsw   m4,        m3, [r4 + 7 * 16]          ; [23]
    pmulhrsw    m4,        m7
    pmaddubsw   m5,        m3, [r4 - 2 * 16]          ; [14]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    pmaddubsw   m5,        m3, [r4 - 11 * 16]         ; [05]
    pmulhrsw    m5,        m7

    palignr     m3,        m2, 14

    pmaddubsw   m6,        m3, [r4 + 12 * 16]         ; [28]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pmaddubsw   m6,        m3, [r4 + 3 * 16]          ; [19]
    pmulhrsw    m6,        m7
    pmaddubsw   m0,        m3, [r4 - 6 * 16]          ; [10]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0

    pmaddubsw   m1,        m3, [r4 - 15 * 16]         ; [01]
    pmulhrsw    m1,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m0,        m3, [r4 + 8 * 16]          ; [24]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0

    TRANSPOSE_STORE_8x8 0, 1, m4, m5, m6, m1

    pmaddubsw   m4,        m3, [r4 - 16]              ; [15]
    pmulhrsw    m4,        m7
    pmaddubsw   m5,        m3, [r4 - 10 * 16]         ; [06]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m5,        m3, [r4 + 13 * 16]         ; [29]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m3, [r4 + 4  * 16]         ; [20]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pmaddubsw   m6,        m3, [r4 - 5 * 16]          ; [11]
    pmulhrsw    m6,        m7
    pmaddubsw   m1,        m3, [r4 - 14 * 16]         ; [02]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m1,        m3, [r4 + 9 * 16]          ; [25]
    pmulhrsw    m1,        m7
    pmaddubsw   m3,        [r4]                       ; [16]
    pmulhrsw    m3,        m7
    packuswb    m1,        m3

    TRANSPOSE_STORE_8x8 1, 1, m4, m5, m6, m1
    RET

INIT_XMM sse4
cglobal intra_pred_ang16_23, 4,7,8
    lea         r4,        [ang_table + 16 * 16]
    lea         r5,        [r1 * 3]                   ; r5 -> 3 * stride
    mov         r6,        r0
    mova        m7,        [pw_1024]

    movu        m3,        [r2]                       ; [15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0]
    punpckhbw   m5,        m3, m3                     ; [15 15 14 14 13 13 12 12 11 11 10 10 9 9 8 8]
    punpcklbw   m3,        m3                         ; [7 7 6 6 5 5 4 4 3 3 2 2 1 1 0 0]
    movu        m2,        [r2 + 32]
    pshufb      m2,        [c_mode16_13]

    palignr     m5,        m3, 1                      ; [8 7 7 6 6 5 5 4 4 3 3 2 2 1 1 0]

    pmaddubsw   m4,        m5, [r4 + 7 * 16]          ; [23]
    pmulhrsw    m4,        m7
    pmaddubsw   m0,        m5, [r4 - 2 * 16]          ; [14]
    pmulhrsw    m0,        m7
    packuswb    m4,        m0

    pmaddubsw   m5,        [r4 - 11 * 16]             ; [05]
    pmulhrsw    m5,        m7

    palignr     m3,        m2, 15

    pmaddubsw   m6,        m3, [r4 + 12 * 16]         ; [28]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pmaddubsw   m6,        m3, [r4 + 3 * 16]          ; [19]
    pmulhrsw    m6,        m7
    pmaddubsw   m0,        m3, [r4 - 6 * 16]          ; [10]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0

    pmaddubsw   m1,        m3, [r4 - 15 * 16]         ; [01]
    pmulhrsw    m1,        m7

    palignr     m3,       m2, 14

    pmaddubsw   m0,        m3, [r4 + 8 * 16]          ; [24]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0

    TRANSPOSE_STORE_8x8 0, 0, m4, m5, m6, m1

    pmaddubsw   m4,        m3, [r4 - 16]              ; [15]
    pmulhrsw    m4,        m7
    pmaddubsw   m5,        m3, [r4 - 10 * 16]         ; [06]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m5,        m3, [r4 + 13 * 16]         ; [29]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m3, [r4 + 4  * 16]         ; [20]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pmaddubsw   m6,        m3, [r4 - 5 * 16]          ; [11]
    pmulhrsw    m6,        m7
    pmaddubsw   m1,        m3, [r4 - 14 * 16]         ; [02]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m1,        m3, [r4 + 9 * 16]          ; [25]
    pmulhrsw    m1,        m7
    pmaddubsw   m3,        [r4]                       ; [16]
    pmulhrsw    m3,        m7
    packuswb    m1,        m3

    TRANSPOSE_STORE_8x8 1, 0, m4, m5, m6, m1

    lea         r0,        [r6 + 8]

    movu        m1,        [r2 + 1]                   ; [16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1]
    pslldq      m3,        m1, 1                      ; [15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 x]
    punpckhbw   m3,        m1                         ; [16 15 15 14 14 13 13 12 12 11 11 10 10 9 9 8]
    movlhps     m2,        m1                         ; [8 7 6 5 4 3 2 1 x x x x x x x]

    pmaddubsw   m4,        m3, [r4 + 7 * 16]          ; [23]
    pmulhrsw    m4,        m7
    pmaddubsw   m5,        m3, [r4 - 2 * 16]          ; [14]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    pmaddubsw   m5,        m3, [r4 - 11 * 16]         ; [05]
    pmulhrsw    m5,        m7

    palignr     m3,        m2, 14

    pmaddubsw   m6,        m3, [r4 + 12 * 16]         ; [28]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pmaddubsw   m6,        m3, [r4 + 3 * 16]          ; [19]
    pmulhrsw    m6,        m7
    pmaddubsw   m0,        m3, [r4 - 6 * 16]          ; [10]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0

    pmaddubsw   m1,        m3, [r4 - 15 * 16]         ; [01]
    pmulhrsw    m1,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m0,        m3, [r4 + 8 * 16]          ; [24]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0

    TRANSPOSE_STORE_8x8 0, 0, m4, m5, m6, m1

    pmaddubsw   m4,        m3, [r4 - 16]              ; [15]
    pmulhrsw    m4,        m7
    pmaddubsw   m5,        m3, [r4 - 10 * 16]         ; [06]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m5,        m3, [r4 + 13 * 16]         ; [29]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m3, [r4 + 4  * 16]         ; [20]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pmaddubsw   m6,        m3, [r4 - 5 * 16]          ; [11]
    pmulhrsw    m6,        m7
    pmaddubsw   m1,        m3, [r4 - 14 * 16]         ; [02]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m1,        m3, [r4 + 9 * 16]          ; [25]
    pmulhrsw    m1,        m7
    pmaddubsw   m3,        [r4]                       ; [16]
    pmulhrsw    m3,        m7
    packuswb    m1,        m3

    TRANSPOSE_STORE_8x8 1, 0, m4, m5, m6, m1
    RET

INIT_XMM sse4
cglobal intra_pred_ang16_14, 4,7,8
    lea         r4,        [ang_table + 16 * 16]
    lea         r5,        [r1 * 3]                   ; r5 -> 3 * stride
    lea         r6,        [r0 + r1 * 4]              ; r6 -> 4 * stride
    mova        m7,        [pw_1024]

    movu        m3,        [r2 + 32]                  ; [15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0]
    pinsrb      m3,        [r2], 0
    punpckhbw   m5,        m3, m3                     ; [15 15 14 14 13 13 12 12 11 11 10 10 9 9 8 8]
    punpcklbw   m3,        m3                         ; [7 7 6 6 5 5 4 4 3 3 2 2 1 1 0 0]
    movu        m2,        [r2]
    pshufb      m2,        [c_mode16_14]

    palignr     m5,        m3, 1                      ; [8 7 7 6 6 5 5 4 4 3 3 2 2 1 1 0]

    pmaddubsw   m4,        m5, [r4 + 3 * 16]          ; [19]
    pmulhrsw    m4,        m7
    pmaddubsw   m5,        [r4 - 10 * 16]             ; [06]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    palignr     m3,        m2, 15

    pmaddubsw   m5,        m3, [r4 + 9 * 16]          ; [25]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m3, [r4 - 4 * 16]          ; [12]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 + 15 * 16]         ; [31]
    pmulhrsw    m6,        m7
    pmaddubsw   m0,        m3, [r4 + 2 * 16]          ; [18]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0

    pmaddubsw   m1,        m3, [r4 - 11 * 16]         ; [05]
    pmulhrsw    m1,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m0,        m3, [r4 + 8 * 16]          ; [24]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0

    TRANSPOSE_STORE_8x8 0, 1, m4, m5, m6, m1

    pmaddubsw   m4,        m3, [r4 - 5 * 16]          ; [11]
    pmulhrsw    m4,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m5,        m3, [r4 + 14 * 16]         ; [30]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    pmaddubsw   m5,        m3, [r4 + 16]              ; [17]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m3, [r4 - 12 * 16]         ; [04]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 + 7 * 16]          ; [23]
    pmulhrsw    m6,        m7
    pmaddubsw   m1,        m3, [r4 - 6  * 16]         ; [10]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m1,        m3, [r4 + 13 * 16]         ; [29]
    pmulhrsw    m1,        m7
    pmaddubsw   m3,        [r4]                       ; [16]
    pmulhrsw    m3,        m7
    packuswb    m1,        m3

    TRANSPOSE_STORE_8x8 1, 1, m4, m5, m6, m1

    lea         r0,        [r6 + r1 * 4]
    lea         r6,        [r6 + r1 * 8]

    movu        m1,        [r2 + 1 + 32]              ; [16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1]
    pslldq      m3,        m1, 1                      ; [15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 x]
    punpckhbw   m3,        m1                         ; [16 15 15 14 14 13 13 12 12 11 11 10 10 9 9 8]
    movlhps     m2,        m1                         ; [8 7 6 5 4 3 2 1 x x x x x x x]

    pmaddubsw   m4,        m3, [r4 + 3 * 16]          ; [19]
    pmulhrsw    m4,        m7
    pmaddubsw   m5,        m3, [r4 - 10 * 16]         ; [06]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    palignr     m3,        m2, 14

    pmaddubsw   m5,        m3, [r4 + 9 * 16]          ; [25]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m3, [r4 - 4 * 16]          ; [12]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 + 15 * 16]         ; [31]
    pmulhrsw    m6,        m7
    pmaddubsw   m0,        m3, [r4 + 2 * 16]          ; [18]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0

    pmaddubsw   m1,        m3, [r4 - 11 * 16]         ; [05]
    pmulhrsw    m1,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m0,        m3, [r4 + 8 * 16]          ; [24]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0

    TRANSPOSE_STORE_8x8 0, 1, m4, m5, m6, m1

    pmaddubsw   m4,        m3, [r4 - 5 * 16]          ; [11]
    pmulhrsw    m4,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m5,        m3, [r4 + 14 * 16]         ; [30]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    pmaddubsw   m5,        m3, [r4 + 16]              ; [17]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m3, [r4 - 12 * 16]         ; [04]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 + 7 * 16]          ; [23]
    pmulhrsw    m6,        m7
    pmaddubsw   m1,        m3, [r4 - 6  * 16]         ; [10]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m1,        m3, [r4 + 13 * 16]         ; [29]
    pmulhrsw    m1,        m7
    pmaddubsw   m3,        [r4]                       ; [16]
    pmulhrsw    m3,        m7
    packuswb    m1,        m3

    TRANSPOSE_STORE_8x8 1, 1, m4, m5, m6, m1
    RET

INIT_XMM sse4
cglobal intra_pred_ang16_22, 4,7,8
    lea         r4,        [ang_table + 16 * 16]
    lea         r5,        [r1 * 3]                   ; r5 -> 3 * stride
    mov         r6,        r0
    mova        m7,        [pw_1024]

    movu        m3,        [r2]                       ; [15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0]
    punpckhbw   m5,        m3, m3                     ; [15 15 14 14 13 13 12 12 11 11 10 10 9 9 8 8]
    punpcklbw   m3,        m3                         ; [7 7 6 6 5 5 4 4 3 3 2 2 1 1 0 0]
    movu        m2,        [r2 + 32]
    pshufb      m2,        [c_mode16_14]

    palignr     m5,        m3, 1                      ; [8 7 7 6 6 5 5 4 4 3 3 2 2 1 1 0]

    pmaddubsw   m4,        m5, [r4 + 3 * 16]          ; [19]
    pmulhrsw    m4,        m7
    pmaddubsw   m5,        [r4 - 10 * 16]             ; [06]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    palignr     m3,        m2, 15

    pmaddubsw   m5,        m3, [r4 + 9 * 16]          ; [25]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m3, [r4 - 4 * 16]          ; [12]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 + 15 * 16]         ; [31]
    pmulhrsw    m6,        m7
    pmaddubsw   m0,        m3, [r4 + 2 * 16]          ; [18]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0

    pmaddubsw   m1,        m3, [r4 - 11 * 16]         ; [05]
    pmulhrsw    m1,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m0,        m3, [r4 + 8 * 16]          ; [24]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0

    TRANSPOSE_STORE_8x8 0, 0, m4, m5, m6, m1

    pmaddubsw   m4,        m3, [r4 - 5 * 16]          ; [11]
    pmulhrsw    m4,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m5,        m3, [r4 + 14 * 16]         ; [30]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    pmaddubsw   m5,        m3, [r4 + 16]              ; [17]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m3, [r4 - 12 * 16]         ; [04]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 + 7 * 16]          ; [23]
    pmulhrsw    m6,        m7
    pmaddubsw   m1,        m3, [r4 - 6  * 16]         ; [10]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m1,        m3, [r4 + 13 * 16]         ; [29]
    pmulhrsw    m1,        m7
    pmaddubsw   m3,        [r4]                       ; [16]
    pmulhrsw    m3,        m7
    packuswb    m1,        m3

    TRANSPOSE_STORE_8x8 1, 0, m4, m5, m6, m1

    lea         r0,        [r6 + 8]

    movu        m1,        [r2 + 1]                   ; [16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1]
    pslldq      m3,        m1, 1                      ; [15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 x]
    punpckhbw   m3,        m1                         ; [16 15 15 14 14 13 13 12 12 11 11 10 10 9 9 8]
    movlhps     m2,        m1                         ; [8 7 6 5 4 3 2 1 x x x x x x x]

    pmaddubsw   m4,        m3, [r4 + 3 * 16]          ; [19]
    pmulhrsw    m4,        m7
    pmaddubsw   m5,        m3, [r4 - 10 * 16]         ; [06]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    palignr     m3,        m2, 14

    pmaddubsw   m5,        m3, [r4 + 9 * 16]          ; [25]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m3, [r4 - 4 * 16]          ; [12]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 + 15 * 16]         ; [31]
    pmulhrsw    m6,        m7
    pmaddubsw   m0,        m3, [r4 + 2 * 16]          ; [18]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0

    pmaddubsw   m1,        m3, [r4 - 11 * 16]         ; [05]
    pmulhrsw    m1,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m0,        m3, [r4 + 8 * 16]          ; [24]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0

    TRANSPOSE_STORE_8x8 0, 0, m4, m5, m6, m1

    pmaddubsw   m4,        m3, [r4 - 5 * 16]          ; [11]
    pmulhrsw    m4,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m5,        m3, [r4 + 14 * 16]         ; [30]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    pmaddubsw   m5,        m3, [r4 + 16]              ; [17]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m3, [r4 - 12 * 16]         ; [04]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 + 7 * 16]          ; [23]
    pmulhrsw    m6,        m7
    pmaddubsw   m1,        m3, [r4 - 6  * 16]         ; [10]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m1,        m3, [r4 + 13 * 16]         ; [29]
    pmulhrsw    m1,        m7
    pmaddubsw   m3,        [r4]                       ; [16]
    pmulhrsw    m3,        m7
    packuswb    m1,        m3

    TRANSPOSE_STORE_8x8 1, 0, m4, m5, m6, m1
    RET

INIT_XMM sse4
cglobal intra_pred_ang16_15, 4,7,8
    lea         r4,        [ang_table + 16 * 16]
    lea         r5,        [r1 * 3]                   ; r5 -> 3 * stride
    lea         r6,        [r0 + r1 * 4]              ; r6 -> 4 * stride
    mova        m7,        [pw_1024]

    movu        m3,        [r2 + 32]                  ; [15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0]
    pinsrb      m3,        [r2], 0
    punpckhbw   m4,        m3, m3                     ; [15 15 14 14 13 13 12 12 11 11 10 10 9 9 8 8]
    punpcklbw   m3,        m3                         ; [7 7 6 6 5 5 4 4 3 3 2 2 1 1 0 0]
    movu        m2,        [r2]
    pshufb      m2,        [c_mode16_15]

    palignr     m4,        m3, 1                      ; [8 7 7 6 6 5 5 4 4 3 3 2 2 1 1 0]

    pmaddubsw   m4,        [r4 - 16]                  ; [15]
    pmulhrsw    m4,        m7

    palignr     m3,        m2, 15

    pmaddubsw   m5,        m3, [r4 + 14 * 16]         ; [30]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    pmaddubsw   m5,        m3, [r4 - 3 * 16]          ; [13]
    pmulhrsw    m5,        m7

    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 + 12 * 16]         ; [28]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pmaddubsw   m6,        m3, [r4 - 5 * 16]          ; [11]
    pmulhrsw    m6,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m0,        m3, [r4 + 10 * 16]         ; [26]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0

    pmaddubsw   m1,        m3, [r4 - 7 * 16]          ; [09]
    pmulhrsw    m1,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m0,        m3, [r4 + 8 * 16]          ; [24]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0

    TRANSPOSE_STORE_8x8 0, 1, m4, m5, m6, m1

    pmaddubsw   m4,        m3, [r4 - 9  * 16]         ; [07]
    pmulhrsw    m4,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m5,        m3, [r4 + 6  * 16]         ; [22]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    pmaddubsw   m5,        m3, [r4 - 11 * 16]         ; [05]
    pmulhrsw    m5,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 + 4  * 16]         ; [20]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pmaddubsw   m6,        m3, [r4 - 13 * 16]         ; [03]
    pmulhrsw    m6,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m1,        m3, [r4 + 2  * 16]         ; [18]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1

    pmaddubsw   m1,        m3, [r4 - 15 * 16]         ; [01]
    pmulhrsw    m1,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m3,        [r4]                       ; [16]
    pmulhrsw    m3,        m7
    packuswb    m1,        m3

    TRANSPOSE_STORE_8x8 1, 1, m4, m5, m6, m1

    lea         r0,        [r6 + r1 * 4]
    lea         r6,        [r6 + r1 * 8]

    movu        m1,        [r2 + 1 + 32]              ; [16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1]
    pslldq      m3,        m1, 1                      ; [15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 x]
    punpckhbw   m3,        m1                         ; [16 15 15 14 14 13 13 12 12 11 11 10 10 9 9 8]
    movlhps     m2,        m1                         ; [8 7 6 5 4 3 2 1 0 0 0 0 0 0 0 15L]

    pmaddubsw   m4,        m3, [r4 - 16]              ; [15]
    pmulhrsw    m4,        m7

    palignr     m3,        m2, 14

    pmaddubsw   m5,        m3, [r4 + 14 * 16]         ; [30]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    pmaddubsw   m5,        m3, [r4 - 3 * 16]          ; [13]
    pmulhrsw    m5,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 + 12 * 16]         ; [28]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pmaddubsw   m6,        m3, [r4 -  5 * 16]         ; [11]
    pmulhrsw    m6,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m0,        m3, [r4 + 10 * 16]         ; [26]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0

    pmaddubsw   m1,        m3, [r4 - 7  * 16]         ; [09]
    pmulhrsw    m1,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m0,        m3, [r4 + 8 * 16]          ; [24]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0

    TRANSPOSE_STORE_8x8 0, 1, m4, m5, m6, m1

    pmaddubsw   m4,        m3, [r4 - 9  * 16]         ; [07]
    pmulhrsw    m4,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m5,        m3, [r4 + 6  * 16]         ; [22]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    pmaddubsw   m5,        m3, [r4 - 11 * 16]         ; [05]
    pmulhrsw    m5,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 +  4 * 16]         ; [20]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pmaddubsw   m6,        m3, [r4 - 13 * 16]         ; [03]
    pmulhrsw    m6,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m1,        m3, [r4 + 2  * 16]         ; [18]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1

    pmaddubsw   m1,        m3, [r4 - 15 * 16]         ; [01]
    pmulhrsw    m1,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m3,        [r4]                       ; [16]
    pmulhrsw    m3,        m7
    packuswb    m1,        m3

    TRANSPOSE_STORE_8x8 1, 1, m4, m5, m6, m1
    RET

INIT_XMM sse4
cglobal intra_pred_ang16_21, 4,7,8
    lea         r4,        [ang_table + 16 * 16]
    lea         r5,        [r1 * 3]                   ; r5 -> 3 * stride
    mov         r6,        r0
    mova        m7,        [pw_1024]

    movu        m3,        [r2]                       ; [15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0]
    punpckhbw   m4,        m3, m3                     ; [15 15 14 14 13 13 12 12 11 11 10 10 9 9 8 8]
    punpcklbw   m3,        m3                         ; [7 7 6 6 5 5 4 4 3 3 2 2 1 1 0 0]
    movu        m2,        [r2 + 32]
    pinsrb      m2,        [r2], 0
    pshufb      m2,        [c_mode16_15]

    palignr     m4,        m3, 1                      ; [8 7 7 6 6 5 5 4 4 3 3 2 2 1 1 0]

    pmaddubsw   m4,        [r4 - 16]                  ; [15]
    pmulhrsw    m4,        m7

    palignr     m3,        m2, 15

    pmaddubsw   m5,        m3, [r4 + 14 * 16]         ; [30]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    pmaddubsw   m5,        m3, [r4 - 3 * 16]          ; [13]
    pmulhrsw    m5,        m7

    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 + 12 * 16]         ; [28]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pmaddubsw   m6,        m3, [r4 - 5 * 16]          ; [11]
    pmulhrsw    m6,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m0,        m3, [r4 + 10 * 16]         ; [26]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0

    pmaddubsw   m1,        m3, [r4 - 7 * 16]          ; [09]
    pmulhrsw    m1,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m0,        m3, [r4 + 8 * 16]          ; [24]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0

    TRANSPOSE_STORE_8x8 0, 0, m4, m5, m6, m1

    pmaddubsw   m4,        m3, [r4 - 9  * 16]         ; [07]
    pmulhrsw    m4,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m5,        m3, [r4 + 6  * 16]         ; [22]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    pmaddubsw   m5,        m3, [r4 - 11 * 16]         ; [05]
    pmulhrsw    m5,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 + 4  * 16]         ; [20]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pmaddubsw   m6,        m3, [r4 - 13 * 16]         ; [03]
    pmulhrsw    m6,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m1,        m3, [r4 + 2  * 16]         ; [18]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1

    pmaddubsw   m1,        m3, [r4 - 15 * 16]         ; [01]
    pmulhrsw    m1,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m3,        [r4]                       ; [16]
    pmulhrsw    m3,        m7
    packuswb    m1,        m3

    TRANSPOSE_STORE_8x8 1, 0, m4, m5, m6, m1

    lea         r0,        [r6 + 8]

    movu        m1,        [r2 + 1]                   ; [16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1]
    pslldq      m3,        m1, 1                      ; [15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 x]
    punpckhbw   m3,        m1                         ; [16 15 15 14 14 13 13 12 12 11 11 10 10 9 9 8]
    movlhps     m2,        m1                         ; [8 7 6 5 4 3 2 1 0 0 0 0 0 0 0 15L]

    pmaddubsw   m4,        m3, [r4 - 16]              ; [15]
    pmulhrsw    m4,        m7

    palignr     m3,        m2, 14

    pmaddubsw   m5,        m3, [r4 + 14 * 16]         ; [30]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    pmaddubsw   m5,        m3, [r4 - 3 * 16]          ; [13]
    pmulhrsw    m5,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 + 12 * 16]         ; [28]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pmaddubsw   m6,        m3, [r4 -  5 * 16]         ; [11]
    pmulhrsw    m6,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m0,        m3, [r4 + 10 * 16]         ; [26]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0

    pmaddubsw   m1,        m3, [r4 - 7  * 16]         ; [09]
    pmulhrsw    m1,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m0,        m3, [r4 + 8 * 16]          ; [24]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0

    TRANSPOSE_STORE_8x8 0, 0, m4, m5, m6, m1

    pmaddubsw   m4,        m3, [r4 - 9  * 16]         ; [07]
    pmulhrsw    m4,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m5,        m3, [r4 + 6  * 16]         ; [22]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    pmaddubsw   m5,        m3, [r4 - 11 * 16]         ; [05]
    pmulhrsw    m5,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 +  4 * 16]         ; [20]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pmaddubsw   m6,        m3, [r4 - 13 * 16]         ; [03]
    pmulhrsw    m6,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m1,        m3, [r4 + 2  * 16]         ; [18]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1

    pmaddubsw   m1,        m3, [r4 - 15 * 16]         ; [01]
    pmulhrsw    m1,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m3,        [r4]                       ; [16]
    pmulhrsw    m3,        m7
    packuswb    m1,        m3

    TRANSPOSE_STORE_8x8 1, 0, m4, m5, m6, m1
    RET

INIT_XMM sse4
cglobal intra_pred_ang16_16, 4,7,8
    lea         r4,        [ang_table + 16 * 16]
    lea         r5,        [r1 * 3]                   ; r5 -> 3 * stride
    lea         r6,        [r0 + r1 * 4]              ; r6 -> 4 * stride
    mova        m7,        [pw_1024]

    movu        m3,        [r2 + 32]                  ; [15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0]
    pinsrb      m3,        [r2], 0
    punpckhbw   m4,        m3, m3                     ; [15 15 14 14 13 13 12 12 11 11 10 10 9 9 8 8]
    punpcklbw   m3,        m3                         ; [7 7 6 6 5 5 4 4 3 3 2 2 1 1 0 0]
    movu        m2,        [r2]
    pshufb      m2,        [c_mode16_16]              ; [2, 3, 5, 6, 8, 9, 11, 12, 14, 15, 0, 2, 3, 5, 6, 8]
    palignr     m4,        m3, 1                      ; [8 7 7 6 6 5 5 4 4 3 3 2 2 1 1 0]

    pmaddubsw   m4,        [r4 - 5  * 16]             ; [11]
    pmulhrsw    m4,        m7

    palignr     m3,        m2, 15

    pmaddubsw   m5,        m3, [r4 + 6  * 16]         ; [22]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    pmaddubsw   m5,        m3, [r4 - 15 * 16]         ; [01]
    pmulhrsw    m5,        m7

    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 - 4  * 16]         ; [12]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pslldq      m2,       1                           ; [3, 5, 6, 8, 9, 11, 12, 14, 15, 0, 2, 3, 5, 6, 8, x]
    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 + 7  * 16]         ; [23]
    pmulhrsw    m6,        m7
    pmaddubsw   m0,        m3, [r4 - 14 * 16]         ; [02]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0

    pslldq      m2,       1                           ; [5, 6, 8, 9, 11, 12, 14, 15, 0, 2, 3, 5, 6, 8, x, x]
    palignr     m3,       m2, 14

    pmaddubsw   m1,        m3, [r4 - 3  * 16]         ; [13]
    pmulhrsw    m1,        m7

    pslldq      m2,       1                           ; [6, 8, 9, 11, 12, 14, 15, 0, 2, 3, 5, 6, 8, x, x, x]
    palignr     m3,       m2, 14

    pmaddubsw   m0,        m3, [r4 + 8 * 16]          ; [24]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0

    TRANSPOSE_STORE_8x8 0, 1, m4, m5, m6, m1

    pmaddubsw   m4,        m3, [r4 - 13 * 16]         ; [03]
    pmulhrsw    m4,        m7

    pslldq      m2,       1                           ; [8, 9, 11, 12, 14, 15, 0, 2, 3, 5, 6, 8, x, x, x, x]
    palignr     m3,       m2, 14

    pmaddubsw   m5,        m3, [r4 - 2  * 16]         ; [14]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    pslldq      m2,       1                           ; [9, 11, 12, 14, 15, 0, 2, 3, 5, 6, 8, x, x, x, x, x]
    palignr     m3,       m2, 14

    pmaddubsw   m5,        m3, [r4 + 9  * 16]         ; [25]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m3, [r4 - 12 * 16]         ; [04]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pslldq      m2,       1                           ; [11, 12, 14, 15, 0, 2, 3, 5, 6, 8, x, x, x, x, x, x]
    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 - 16]              ; [15]
    pmulhrsw    m6,        m7

    pslldq      m2,       1                           ; [12, 14, 15, 0, 2, 3, 5, 6, 8, x, x, x, x, x, x, x]
    palignr     m3,       m2, 14

    pmaddubsw   m1,        m3, [r4 + 10 * 16]         ; [26]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1

    pmaddubsw   m1,        m3, [r4 - 11 * 16]         ; [05]
    pmulhrsw    m1,        m7

    pslldq      m2,       1                           ; [14, 15, 0, 2, 3, 5, 6, 8, x, x, x, x, x, x, x, x]
    palignr     m3,       m2, 14

    pmaddubsw   m3,        [r4]                       ; [16]
    pmulhrsw    m3,        m7
    packuswb    m1,        m3

    TRANSPOSE_STORE_8x8 1, 1, m4, m5, m6, m1

    lea         r0,        [r6 + r1 * 4]
    lea         r6,        [r6 + r1 * 8]

    movu        m1,        [r2 + 1 + 32]              ; [16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1]
    pslldq      m3,        m1, 1                      ; [15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 x]
    punpckhbw   m3,        m1                         ; [16 15 15 14 14 13 13 12 12 11 11 10 10 9 9 8]
    palignr     m2,        m2, 6                      ; [x, x, x, x, x, x, 14, 15, 0, 2, 3, 5, 6, 8, x, x]
    movlhps     m2,        m1                         ; [8 7 6 5 4 3 2 1 0, 2, 3, 5, 6, 8, x, x]

    pmaddubsw   m4,        m3, [r4 - 5  * 16]         ; [11]
    pmulhrsw    m4,        m7

    palignr     m3,        m2, 14

    pmaddubsw   m5,        m3, [r4 + 6  * 16]         ; [22]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    pmaddubsw   m5,        m3, [r4 - 15 * 16]         ; [01]
    pmulhrsw    m5,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 - 4  * 16]         ; [12]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 + 7  * 16]         ; [23]
    pmulhrsw    m6,        m7

    pmaddubsw   m0,        m3, [r4 - 14 * 16]         ; [02]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m1,        m3, [r4 - 3  * 16]         ; [13]
    pmulhrsw    m1,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m0,        m3, [r4 + 8 * 16]          ; [24]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0

    TRANSPOSE_STORE_8x8 0, 1, m4, m5, m6, m1

    pmaddubsw   m4,        m3, [r4 - 13 * 16]         ; [03]
    pmulhrsw    m4,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m5,        m3, [r4 - 2  * 16]         ; [14]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m5,        m3, [r4 +  9 * 16]         ; [25]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m3, [r4 - 12 * 16]         ; [04]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 - 16]              ; [15]
    pmulhrsw    m6,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m1,        m3, [r4 + 10 * 16]         ; [26]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1

    pmaddubsw   m1,        m3, [r4 - 11 * 16]         ; [05]
    pmulhrsw    m1,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m3,        [r4]                       ; [16]
    pmulhrsw    m3,        m7
    packuswb    m1,        m3

    TRANSPOSE_STORE_8x8 1, 1, m4, m5, m6, m1
    RET

INIT_XMM sse4
cglobal intra_pred_ang16_20, 4,7,8
    lea         r4,        [ang_table + 16 * 16]
    lea         r5,        [r1 * 3]                   ; r5 -> 3 * stride
    mov         r6,        r0
    mova        m7,        [pw_1024]

    movu        m3,        [r2]                       ; [15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0]
    punpckhbw   m4,        m3, m3                     ; [15 15 14 14 13 13 12 12 11 11 10 10 9 9 8 8]
    punpcklbw   m3,        m3                         ; [7 7 6 6 5 5 4 4 3 3 2 2 1 1 0 0]
    movu        m2,        [r2 + 32]
    pinsrb      m2,        [r2], 0
    pshufb      m2,        [c_mode16_16]              ; [2, 3, 5, 6, 8, 9, 11, 12, 14, 15, 0, 2, 3, 5, 6, 8]
    palignr     m4,        m3, 1                      ; [8 7 7 6 6 5 5 4 4 3 3 2 2 1 1 0]

    pmaddubsw   m4,        [r4 - 5  * 16]             ; [11]
    pmulhrsw    m4,        m7

    palignr     m3,        m2, 15

    pmaddubsw   m5,        m3, [r4 + 6  * 16]         ; [22]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    pmaddubsw   m5,        m3, [r4 - 15 * 16]         ; [01]
    pmulhrsw    m5,        m7

    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 - 4  * 16]         ; [12]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pslldq      m2,       1                           ; [3, 5, 6, 8, 9, 11, 12, 14, 15, 0, 2, 3, 5, 6, 8, x]
    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 + 7  * 16]         ; [23]
    pmulhrsw    m6,        m7
    pmaddubsw   m0,        m3, [r4 - 14 * 16]         ; [02]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0

    pslldq      m2,       1                           ; [5, 6, 8, 9, 11, 12, 14, 15, 0, 2, 3, 5, 6, 8, x, x]
    palignr     m3,       m2, 14

    pmaddubsw   m1,        m3, [r4 - 3  * 16]         ; [13]
    pmulhrsw    m1,        m7

    pslldq      m2,       1                           ; [6, 8, 9, 11, 12, 14, 15, 0, 2, 3, 5, 6, 8, x, x, x]
    palignr     m3,       m2, 14

    pmaddubsw   m0,        m3, [r4 + 8 * 16]          ; [24]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0

    TRANSPOSE_STORE_8x8 0, 0, m4, m5, m6, m1

    pmaddubsw   m4,        m3, [r4 - 13 * 16]         ; [03]
    pmulhrsw    m4,        m7

    pslldq      m2,       1                           ; [8, 9, 11, 12, 14, 15, 0, 2, 3, 5, 6, 8, x, x, x, x]
    palignr     m3,       m2, 14

    pmaddubsw   m5,        m3, [r4 - 2  * 16]         ; [14]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    pslldq      m2,       1                           ; [9, 11, 12, 14, 15, 0, 2, 3, 5, 6, 8, x, x, x, x, x]
    palignr     m3,       m2, 14

    pmaddubsw   m5,        m3, [r4 + 9  * 16]         ; [25]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m3, [r4 - 12 * 16]         ; [04]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pslldq      m2,       1                           ; [11, 12, 14, 15, 0, 2, 3, 5, 6, 8, x, x, x, x, x, x]
    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 - 16]              ; [15]
    pmulhrsw    m6,        m7

    pslldq      m2,       1                           ; [12, 14, 15, 0, 2, 3, 5, 6, 8, x, x, x, x, x, x, x]
    palignr     m3,       m2, 14

    pmaddubsw   m1,        m3, [r4 + 10 * 16]         ; [26]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1

    pmaddubsw   m1,        m3, [r4 - 11 * 16]         ; [05]
    pmulhrsw    m1,        m7

    pslldq      m2,       1                           ; [14, 15, 0, 2, 3, 5, 6, 8, x, x, x, x, x, x, x, x]
    palignr     m3,       m2, 14

    pmaddubsw   m3,        [r4]                       ; [16]
    pmulhrsw    m3,        m7
    packuswb    m1,        m3

    TRANSPOSE_STORE_8x8 1, 0, m4, m5, m6, m1

    lea         r0,        [r6 + 8]

    movu        m1,        [r2 + 1]                   ; [16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1]
    pslldq      m3,        m1, 1                      ; [15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 x]
    punpckhbw   m3,        m1                         ; [16 15 15 14 14 13 13 12 12 11 11 10 10 9 9 8]
    palignr     m2,        m2, 6                      ; [x, x, x, x, x, x, 14, 15, 0, 2, 3, 5, 6, 8, x, x]
    movlhps     m2,        m1                         ; [8 7 6 5 4 3 2 1 0, 2, 3, 5, 6, 8, x, x]

    pmaddubsw   m4,        m3, [r4 - 5  * 16]         ; [11]
    pmulhrsw    m4,        m7

    palignr     m3,        m2, 14

    pmaddubsw   m5,        m3, [r4 + 6  * 16]         ; [22]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    pmaddubsw   m5,        m3, [r4 - 15 * 16]         ; [01]
    pmulhrsw    m5,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 - 4  * 16]         ; [12]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 + 7  * 16]         ; [23]
    pmulhrsw    m6,        m7

    pmaddubsw   m0,        m3, [r4 - 14 * 16]         ; [02]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m1,        m3, [r4 - 3  * 16]         ; [13]
    pmulhrsw    m1,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m0,        m3, [r4 + 8 * 16]          ; [24]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0

    TRANSPOSE_STORE_8x8 0, 0, m4, m5, m6, m1

    pmaddubsw   m4,        m3, [r4 - 13 * 16]         ; [03]
    pmulhrsw    m4,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m5,        m3, [r4 - 2  * 16]         ; [14]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m5,        m3, [r4 +  9 * 16]         ; [25]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m3, [r4 - 12 * 16]         ; [04]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 - 16]              ; [15]
    pmulhrsw    m6,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m1,        m3, [r4 + 10 * 16]         ; [26]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1

    pmaddubsw   m1,        m3, [r4 - 11 * 16]         ; [05]
    pmulhrsw    m1,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m3,        [r4]                       ; [16]
    pmulhrsw    m3,        m7
    packuswb    m1,        m3

    TRANSPOSE_STORE_8x8 1, 0, m4, m5, m6, m1
    RET

INIT_XMM sse4
cglobal intra_pred_ang16_17, 4,7,8
    lea         r4,        [ang_table + 16 * 16]
    lea         r5,        [r1 * 3]                   ; r5 -> 3 * stride
    lea         r6,        [r0 + r1 * 4]              ; r6 -> 4 * stride
    mova        m7,        [pw_1024]

    movu        m3,        [r2 + 32]                  ; [15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0]
    pinsrb      m3,        [r2], 0
    punpckhbw   m4,        m3, m3                     ; [15 15 14 14 13 13 12 12 11 11 10 10 9 9 8 8]
    punpcklbw   m3,        m3                         ; [7 7 6 6 5 5 4 4 3 3 2 2 1 1 0 0]
    movu        m2,        [r2]
    pshufb      m2,        [c_mode16_17]              ; [1, 2, 4, 5, 6, 7, 9, 10, 11, 12, 14, 15, 0, 1, 2, 4]
    palignr     m4,        m3, 1                      ; [8 7 7 6 6 5 5 4 4 3 3 2 2 1 1 0]

    pmaddubsw   m4,        [r4 - 10 * 16]             ; [06]
    pmulhrsw    m4,        m7

    palignr     m3,        m2, 15

    pmaddubsw   m5,        m3, [r4 -  4 * 16]         ; [12]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    palignr     m3,       m2, 14

    pmaddubsw   m5,        m3, [r4 + 2  * 16]         ; [18]
    pmulhrsw    m5,        m7

    pslldq      m2,       1                           ; [2, 4, 5, 6, 7, 9, 10, 11, 12, 14, 15, 0, 1, 2, 4, x]
    pinsrb      m2,       [r2 + 5], 0                 ; [2, 4, 5, 6, 7, 9, 10, 11, 12, 14, 15, 0, 1, 2, 4, 5]
    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 + 8  * 16]         ; [24]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pslldq      m2,       1                           ; [4, 5, 6, 7, 9, 10, 11, 12, 14, 15, 0, 1, 2, 4, 5, x]
    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 + 14 * 16]         ; [30]
    pmulhrsw    m6,        m7
    pmaddubsw   m0,        m3, [r4 - 12 * 16]         ; [04]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0

    pslldq      m2,       1                           ; [5, 6, 7, 9, 10, 11, 12, 14, 15, 0, 1, 2, 4, 5, x, x]
    palignr     m3,       m2, 14

    pmaddubsw   m1,        m3, [r4 - 6  * 16]         ; [10]
    pmulhrsw    m1,        m7

    pslldq      m2,       1                           ; [6, 7, 9, 10, 11, 12, 14, 15, 0, 1, 2, 4, 5, x, x, x]
    palignr     m3,       m2, 14

    pmaddubsw   m0,        m3, [r4]                   ; [16]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0

    TRANSPOSE_STORE_8x8 0, 1, m4, m5, m6, m1

    pslldq      m2,       1                           ; [7, 9, 10, 11, 12, 14, 15, 0, 1, 2, 4, 5, x, x, x, x]
    palignr     m3,       m2, 14

    pmaddubsw   m4,        m3, [r4 + 6  * 16]         ; [22]
    pmulhrsw    m4,        m7

    pslldq      m2,       1                           ; [9, 10, 11, 12, 14, 15, 0, 1, 2, 4, 5, x, x, x, x, x]
    palignr     m3,       m2, 14

    pmaddubsw   m5,        m3, [r4 + 12 * 16]         ; [28]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    pmaddubsw   m5,        m3, [r4 - 14 * 16]         ; [02]
    pmulhrsw    m5,        m7

    pslldq      m2,       1                           ; [10, 11, 12, 14, 15, 0, 1, 2, 4, 5, x, x, x, x, x, x]
    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 -  8 * 16]         ; [08]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pslldq      m2,       1                           ; [11, 12, 14, 15, 0, 1, 2, 4, 5, x, x, x, x, x, x, x]
    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 - 2  * 16]         ; [14]
    pmulhrsw    m6,        m7

    pslldq      m2,       1                           ; [12, 14, 15, 0, 1, 2, 4, 5, x, x, x, x, x, x, x, x]
    palignr     m3,       m2, 14

    pmaddubsw   m1,        m3, [r4 + 4  * 16]         ; [20]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1

    pslldq      m2,       1                           ; [14, 15, 0, 1, 2, 4, 5, x, x, x, x, x, x, x, x, x]
    palignr     m3,       m2, 14

    pmaddubsw   m1,        m3, [r4 + 10 * 16]         ; [26]
    pmulhrsw    m1,        m7
    pmaddubsw   m3,        [r4 - 16 * 16]             ; [00]
    pmulhrsw    m3,        m7
    packuswb    m1,        m3

    TRANSPOSE_STORE_8x8 1, 1, m4, m5, m6, m1

    lea         r0,        [r6 + r1 * 4]
    lea         r6,        [r6 + r1 * 8]

    movu        m1,        [r2 + 1 + 32]              ; [16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1]
    pslldq      m3,        m1, 1                      ; [15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 x]
    punpckhbw   m3,        m1                         ; [16 15 15 14 14 13 13 12 12 11 11 10 10 9 9 8]
    palignr     m2,        m2, 6                      ; [x, x, x, x, x, x, 14, 15, 0, 1, 2, 4, 5, x, x, x]
    movlhps     m2,        m1                         ; [8 7 6 5 4 3 2 1 0, 1, 2, 4, 5, x, x, x]

    pmaddubsw   m4,        m3, [r4 - 10 * 16]         ; [06]
    pmulhrsw    m4,        m7

    palignr     m3,        m2, 14

    pmaddubsw   m5,        m3, [r4 - 4  * 16]         ; [12]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m5,        m3, [r4 + 2  * 16]         ; [18]
    pmulhrsw    m5,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 + 8  * 16]         ; [24]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 + 14 * 16]         ; [30]
    pmulhrsw    m6,        m7
    pmaddubsw   m0,        m3, [r4 - 12 * 16]         ; [04]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m1,        m3, [r4 - 6  * 16]         ; [10]
    pmulhrsw    m1,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m0,        m3, [r4]                   ; [16]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0

    TRANSPOSE_STORE_8x8 0, 1, m4, m5, m6, m1

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m4,        m3, [r4 + 6  * 16]         ; [22]
    pmulhrsw    m4,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m5,        m3, [r4 + 12 * 16]         ; [28]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    pmaddubsw   m5,        m3, [r4 - 14 * 16]         ; [02]
    pmulhrsw    m5,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 -  8 * 16]         ; [08]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 -  2 * 16]         ; [14]
    pmulhrsw    m6,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m1,        m3, [r4 + 4  * 16]         ; [20]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m1,        m3, [r4 + 10 * 16]         ; [26]
    pmulhrsw    m1,        m7
    pmaddubsw   m3,        [r4 - 16 * 16]             ; [00]
    pmulhrsw    m3,        m7
    packuswb    m1,        m3

    TRANSPOSE_STORE_8x8 1, 1, m4, m5, m6, m1
    RET

INIT_XMM sse4
cglobal intra_pred_ang16_19, 4,7,8
    lea         r4,        [ang_table + 16 * 16]
    lea         r5,        [r1 * 3]                   ; r5 -> 3 * stride
    mov         r6,        r0
    mova        m7,        [pw_1024]

    movu        m3,        [r2]                       ; [15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0]
    punpckhbw   m4,        m3, m3                     ; [15 15 14 14 13 13 12 12 11 11 10 10 9 9 8 8]
    punpcklbw   m3,        m3                         ; [7 7 6 6 5 5 4 4 3 3 2 2 1 1 0 0]
    movu        m2,        [r2 + 32]
    pinsrb      m2,        [r2], 0
    pshufb      m2,        [c_mode16_17]              ; [1, 2, 4, 5, 6, 7, 9, 10, 11, 12, 14, 15, 0, 1, 2, 4]
    palignr     m4,        m3, 1                      ; [8 7 7 6 6 5 5 4 4 3 3 2 2 1 1 0]

    pmaddubsw   m4,        [r4 - 10 * 16]             ; [06]
    pmulhrsw    m4,        m7

    palignr     m3,        m2, 15

    pmaddubsw   m5,        m3, [r4 -  4 * 16]         ; [12]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    palignr     m3,       m2, 14

    pmaddubsw   m5,        m3, [r4 + 2  * 16]         ; [18]
    pmulhrsw    m5,        m7

    pslldq      m2,       1                           ; [2, 4, 5, 6, 7, 9, 10, 11, 12, 14, 15, 0, 1, 2, 4, x]
    pinsrb      m2,       [r2 + 5 + 32], 0            ; [2, 4, 5, 6, 7, 9, 10, 11, 12, 14, 15, 0, 1, 2, 4, 5]
    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 + 8  * 16]         ; [24]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pslldq      m2,       1                           ; [4, 5, 6, 7, 9, 10, 11, 12, 14, 15, 0, 1, 2, 4, 5, x]
    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 + 14 * 16]         ; [30]
    pmulhrsw    m6,        m7
    pmaddubsw   m0,        m3, [r4 - 12 * 16]         ; [04]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0

    pslldq      m2,       1                           ; [5, 6, 7, 9, 10, 11, 12, 14, 15, 0, 1, 2, 4, 5, x, x]
    palignr     m3,       m2, 14

    pmaddubsw   m1,        m3, [r4 - 6  * 16]         ; [10]
    pmulhrsw    m1,        m7

    pslldq      m2,       1                           ; [6, 7, 9, 10, 11, 12, 14, 15, 0, 1, 2, 4, 5, x, x, x]
    palignr     m3,       m2, 14

    pmaddubsw   m0,        m3, [r4]                   ; [16]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0

    TRANSPOSE_STORE_8x8 0, 0, m4, m5, m6, m1

    pslldq      m2,       1                           ; [7, 9, 10, 11, 12, 14, 15, 0, 1, 2, 4, 5, x, x, x, x]
    palignr     m3,       m2, 14

    pmaddubsw   m4,        m3, [r4 + 6  * 16]         ; [22]
    pmulhrsw    m4,        m7

    pslldq      m2,       1                           ; [9, 10, 11, 12, 14, 15, 0, 1, 2, 4, 5, x, x, x, x, x]
    palignr     m3,       m2, 14

    pmaddubsw   m5,        m3, [r4 + 12 * 16]         ; [28]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    pmaddubsw   m5,        m3, [r4 - 14 * 16]         ; [02]
    pmulhrsw    m5,        m7

    pslldq      m2,       1                           ; [10, 11, 12, 14, 15, 0, 1, 2, 4, 5, x, x, x, x, x, x]
    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 -  8 * 16]         ; [08]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pslldq      m2,       1                           ; [11, 12, 14, 15, 0, 1, 2, 4, 5, x, x, x, x, x, x, x]
    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 - 2  * 16]         ; [14]
    pmulhrsw    m6,        m7

    pslldq      m2,       1                           ; [12, 14, 15, 0, 1, 2, 4, 5, x, x, x, x, x, x, x, x]
    palignr     m3,       m2, 14

    pmaddubsw   m1,        m3, [r4 + 4  * 16]         ; [20]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1

    pslldq      m2,       1                           ; [14, 15, 0, 1, 2, 4, 5, x, x, x, x, x, x, x, x, x]
    palignr     m3,       m2, 14

    pmaddubsw   m1,        m3, [r4 + 10 * 16]         ; [26]
    pmulhrsw    m1,        m7
    pmaddubsw   m3,        [r4 - 16 * 16]             ; [00]
    pmulhrsw    m3,        m7
    packuswb    m1,        m3

    TRANSPOSE_STORE_8x8 1, 0, m4, m5, m6, m1

    lea         r0,        [r6 + 8]

    movu        m1,        [r2 + 1]                   ; [16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1]
    pslldq      m3,        m1, 1                      ; [15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 x]
    punpckhbw   m3,        m1                         ; [16 15 15 14 14 13 13 12 12 11 11 10 10 9 9 8]
    palignr     m2,        m2, 6                      ; [x, x, x, x, x, 14, 15, 0, 1, 2, 4, 5, x, x, x]
    movlhps     m2,        m1                         ; [8 7 6 5 4 3 2 1 0, 2, 3, 5, 6, 8, x, x]

    pmaddubsw   m4,        m3, [r4 - 10 * 16]         ; [06]
    pmulhrsw    m4,        m7

    palignr     m3,        m2, 14

    pmaddubsw   m5,        m3, [r4 - 4  * 16]         ; [12]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m5,        m3, [r4 + 2  * 16]         ; [18]
    pmulhrsw    m5,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 + 8  * 16]         ; [24]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 + 14 * 16]         ; [30]
    pmulhrsw    m6,        m7
    pmaddubsw   m0,        m3, [r4 - 12 * 16]         ; [04]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m1,        m3, [r4 - 6  * 16]         ; [10]
    pmulhrsw    m1,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m0,        m3, [r4]                   ; [16]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0

    TRANSPOSE_STORE_8x8 0, 0, m4, m5, m6, m1

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m4,        m3, [r4 + 6  * 16]         ; [22]
    pmulhrsw    m4,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m5,        m3, [r4 + 12 * 16]         ; [28]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5

    pmaddubsw   m5,        m3, [r4 - 14 * 16]         ; [02]
    pmulhrsw    m5,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 -  8 * 16]         ; [08]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m6,        m3, [r4 -  2 * 16]         ; [14]
    pmulhrsw    m6,        m7

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m1,        m3, [r4 + 4  * 16]         ; [20]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1

    pslldq      m2,       1
    palignr     m3,       m2, 14

    pmaddubsw   m1,        m3, [r4 + 10 * 16]         ; [26]
    pmulhrsw    m1,        m7
    pmaddubsw   m3,        [r4 - 16 * 16]             ; [00]
    pmulhrsw    m3,        m7
    packuswb    m1,        m3

    TRANSPOSE_STORE_8x8 1, 0, m4, m5, m6, m1
    RET

INIT_XMM sse4
cglobal intra_pred_ang16_18, 4,5,3
    movu        m0,         [r2]
    movu        m1,         [r2 + 32]
    mova        m2,         [c_mode16_18]
    pshufb      m1,         m2

    lea         r2,         [r1 * 2]
    lea         r3,         [r1 * 3]
    lea         r4,         [r1 * 4]
    movu        [r0],       m0
    palignr     m2,         m0, m1, 15
    movu        [r0 + r1],  m2
    palignr     m2,         m0, m1, 14
    movu        [r0 + r2],  m2
    palignr     m2,         m0, m1, 13
    movu        [r0 + r3],  m2
    lea         r0,         [r0 + r4]
    palignr     m2,         m0, m1, 12
    movu        [r0],       m2
    palignr     m2,         m0, m1, 11
    movu        [r0 + r1],  m2
    palignr     m2,         m0, m1, 10
    movu        [r0 + r2],  m2
    palignr     m2,         m0, m1, 9
    movu        [r0 + r3],  m2
    lea         r0,         [r0 + r4]
    palignr     m2,         m0, m1, 8
    movu        [r0],       m2
    palignr     m2,         m0, m1, 7
    movu        [r0 + r1],  m2
    palignr     m2,         m0, m1, 6
    movu        [r0 + r2],  m2
    palignr     m2,         m0, m1, 5
    movu        [r0 + r3],  m2
    lea         r0,         [r0 + r4]
    palignr     m2,         m0, m1, 4
    movu        [r0],       m2
    palignr     m2,         m0, m1, 3
    movu        [r0 + r1],  m2
    palignr     m2,         m0, m1, 2
    movu        [r0 + r2],  m2
    palignr     m0,         m1, 1
    movu        [r0 + r3],  m0
    RET

; Process Intra32x32, input 8x8 in [m0, m1, m2, m3, m4, m5, m6, m7], output 8x8
%macro PROC32_8x8 10  ; col4, transpose[0/1] c0, c1, c2, c3, c4, c5, c6, c7
  %if %3 == 0
  %else
    pshufb      m0, [r3]
    pmaddubsw   m0, [r4 + %3 * 16]
    pmulhrsw    m0, [pw_1024]
  %endif
  %if %4 == 0
    pmovzxbw    m1, m1
  %else
    pshufb      m1, [r3]
    pmaddubsw   m1, [r4 + %4 * 16]
    pmulhrsw    m1, [pw_1024]
  %endif
  %if %3 == 0
    packuswb    m1, m1
    movlhps     m0, m1
  %else
    packuswb    m0, m1
  %endif
    mova        m1, [pw_1024]
  %if %5 == 0
  %else
    pshufb      m2, [r3]
    pmaddubsw   m2, [r4 + %5 * 16]
    pmulhrsw    m2, m1
  %endif
  %if %6 == 0
    pmovzxbw    m3, m3
  %else
    pshufb      m3, [r3]
    pmaddubsw   m3, [r4 + %6 * 16]
    pmulhrsw    m3, m1
  %endif
  %if %5 == 0
    packuswb    m3, m3
    movlhps     m2, m3
  %else
    packuswb    m2, m3
  %endif
  %if %7 == 0
  %else
    pshufb      m4, [r3]
    pmaddubsw   m4, [r4 + %7 * 16]
    pmulhrsw    m4, m1
  %endif
  %if %8 == 0
    pmovzxbw    m5, m5
  %else
    pshufb      m5, [r3]
    pmaddubsw   m5, [r4 + %8 * 16]
    pmulhrsw    m5, m1
  %endif
  %if %7 == 0
    packuswb    m5, m5
    movlhps     m4, m5
  %else
    packuswb    m4, m5
  %endif
  %if %9 == 0
  %else
    pshufb      m6, [r3]
    pmaddubsw   m6, [r4 + %9 * 16]
    pmulhrsw    m6, m1
  %endif
  %if %10 == 0
    pmovzxbw    m7, m7
  %else
    pshufb      m7, [r3]
    pmaddubsw   m7, [r4 + %10 * 16]
    pmulhrsw    m7, m1
  %endif
  %if %9 == 0
    packuswb    m7, m7
    movlhps     m6, m7
  %else
    packuswb    m6, m7
  %endif

  %if %2 == 1
    ; transpose
    punpckhbw   m1,        m0, m2
    punpcklbw   m0,        m2
    punpckhbw   m3,        m0, m1
    punpcklbw   m0,        m1

    punpckhbw   m1,        m4, m6
    punpcklbw   m4,        m6
    punpckhbw   m6,        m4, m1
    punpcklbw   m4,        m1

    punpckhdq   m2,        m0, m4
    punpckldq   m0,        m4
    punpckldq   m4,        m3, m6
    punpckhdq   m3,        m6

    movh        [r0 +       + %1 * 8], m0
    movhps      [r0 +  r1   + %1 * 8], m0
    movh        [r0 +  r1*2 + %1 * 8], m2
    movhps      [r0 +  r5   + %1 * 8], m2
    movh        [r6         + %1 * 8], m4
    movhps      [r6 +  r1   + %1 * 8], m4
    movh        [r6 +  r1*2 + %1 * 8], m3
    movhps      [r6 +  r5   + %1 * 8], m3
  %else
    movh        [r0         ], m0
    movhps      [r0 + r1    ], m0
    movh        [r0 + r1 * 2], m2
    movhps      [r0 + r5    ], m2
    lea         r0, [r0 + r1 * 4]
    movh        [r0         ], m4
    movhps      [r0 + r1    ], m4
    movh        [r0 + r1 * 2], m6
    movhps      [r0 + r5    ], m6
  %endif
%endmacro

%macro MODE_3_33 1
    movu        m0,        [r2 + 1]                   ; [16 15 14 13 12 11 10 9  8 7 6 5 4 3 2 1]
    palignr     m1,        m0, 1                      ; [ x 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2]
    punpckhbw   m2,        m0, m1                     ; [x 16 16 15 15 14 14 13 13 12 12 11 11 10 10 9]
    punpcklbw   m0,        m1                         ; [9 8 8 7 7 6 6 5 5 4 4 3 3 2 2 1]
    palignr     m1,        m2, m0, 2                  ; [10 9 9 8 8 7 7 6 6 5 5 4 4 3 3 2]
    pmaddubsw   m4,        m0, [r3 + 10 * 16]         ; [26]
    pmulhrsw    m4,        m7
    pmaddubsw   m1,        [r3 + 4 * 16]              ; [20]
    pmulhrsw    m1,        m7
    packuswb    m4,        m1
    palignr     m5,        m2, m0, 4
    pmaddubsw   m5,        [r3 - 2 * 16]              ; [14]
    pmulhrsw    m5,        m7
    palignr     m6,        m2, m0, 6
    pmaddubsw   m6,        [r3 - 8 * 16]              ; [ 8]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6
    palignr     m1,        m2, m0, 8
    pmaddubsw   m6,        m1, [r3 - 14 * 16]         ; [ 2]
    pmulhrsw    m6,        m7
    pmaddubsw   m1,        [r3 + 12 * 16]             ; [28]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1
    palignr     m1,        m2, m0, 10
    pmaddubsw   m1,        [r3 + 6 * 16]              ; [22]
    pmulhrsw    m1,        m7
    palignr     m2,        m0, 12
    pmaddubsw   m2,        [r3]                       ; [16]
    pmulhrsw    m2,        m7
    packuswb    m1,        m2

    TRANSPOSE_STORE_8x8 0, %1, m4, m5, m6, m1

    movu        m0,        [r2 + 8]
    palignr     m1,        m0, 1
    punpckhbw   m2,        m0, m1
    punpcklbw   m0,        m1
    palignr     m5,        m2, m0, 2
    pmaddubsw   m4,        m0, [r3 - 6 * 16]          ; [10]
    pmulhrsw    m4,        m7
    pmaddubsw   m1,        m5, [r3 - 12 * 16]         ; [04]
    pmulhrsw    m1,        m7
    packuswb    m4,        m1
    pmaddubsw   m5,        [r3 + 14 * 16]             ; [30]
    pmulhrsw    m5,        m7
    palignr     m6,        m2, m0, 4
    pmaddubsw   m6,        [r3 + 8 * 16]              ; [24]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6
    palignr     m1,        m2, m0, 6
    pmaddubsw   m6,        m1, [r3 + 2 * 16]          ; [18]
    pmulhrsw    m6,        m7
    palignr     m1,        m2, m0, 8
    pmaddubsw   m1,        [r3 - 4 * 16]              ; [12]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1
    palignr     m1,        m2, m0, 10
    pmaddubsw   m1,        [r3 - 10 * 16]             ; [06]
    pmulhrsw    m1,        m7
    packuswb    m1,        m1
    movhps      m1,        [r2 + 14]                  ; [00]

    TRANSPOSE_STORE_8x8 1, %1, m4, m5, m6, m1

    movu        m0,        [r2 + 14]
    palignr     m1,        m0, 1
    punpckhbw   m2,        m0, m1
    punpcklbw   m0,        m1
    palignr     m1,        m2, m0, 2
    pmaddubsw   m4,        m0, [r3 + 10 * 16]         ; [26]
    pmulhrsw    m4,        m7
    pmaddubsw   m1,        [r3 + 4 * 16]              ; [20]
    pmulhrsw    m1,        m7
    packuswb    m4,        m1
    palignr     m5,        m2, m0, 4
    pmaddubsw   m5,        [r3 - 2 * 16]              ; [14]
    pmulhrsw    m5,        m7
    palignr     m6,        m2, m0, 6
    pmaddubsw   m6,        [r3 - 8 * 16]              ; [ 8]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6
    palignr     m1,        m2, m0, 8
    pmaddubsw   m6,        m1, [r3 - 14 * 16]         ; [ 2]
    pmulhrsw    m6,        m7
    pmaddubsw   m1,        [r3 + 12 * 16]             ; [28]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1
    palignr     m1,        m2, m0, 10
    pmaddubsw   m1,        [r3 + 6 * 16]              ; [22]
    pmulhrsw    m1,        m7
    palignr     m2,        m0, 12
    pmaddubsw   m2,        [r3]                       ; [16]
    pmulhrsw    m2,        m7
    packuswb    m1,        m2

    TRANSPOSE_STORE_8x8 2, %1, m4, m5, m6, m1

    movu        m0,        [r2 + 21]
    palignr     m1,        m0, 1
    punpckhbw   m2,        m0, m1
    punpcklbw   m0,        m1
    palignr     m5,        m2, m0, 2
    pmaddubsw   m4,        m0, [r3 - 6 * 16]          ; [10]
    pmulhrsw    m4,        m7
    pmaddubsw   m1,        m5, [r3 - 12 * 16]         ; [04]
    pmulhrsw    m1,        m7
    packuswb    m4,        m1
    pmaddubsw   m5,        [r3 + 14 * 16]             ; [30]
    pmulhrsw    m5,        m7
    palignr     m6,        m2, m0, 4
    pmaddubsw   m6,        [r3 + 8 * 16]              ; [24]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6
    palignr     m1,        m2, m0, 6
    pmaddubsw   m6,        m1, [r3 + 2 * 16]          ; [18]
    pmulhrsw    m6,        m7
    palignr     m1,        m2, m0, 8
    pmaddubsw   m1,        [r3 - 4 * 16]              ; [12]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1
    palignr     m1,        m2, m0, 10
    pmaddubsw   m1,        [r3 - 10 * 16]             ; [06]
    pmulhrsw    m1,        m7
    packuswb    m1,        m1
    movhps      m1,        [r2 + 27]                  ; [00]

    TRANSPOSE_STORE_8x8 3, %1, m4, m5, m6, m1
%endmacro

%macro MODE_4_32 1
    movu        m0,        [r2 + 1]
    palignr     m1,        m0, 1
    punpckhbw   m2,        m0, m1
    punpcklbw   m0,        m1
    palignr     m1,        m2, m0, 2
    mova        m5,        m1
    pmaddubsw   m4,        m0, [r3 + 5 * 16]          ; [21]
    pmulhrsw    m4,        m7
    pmaddubsw   m1,        [r3 - 6 * 16]              ; [10]
    pmulhrsw    m1,        m7
    packuswb    m4,        m1
    pmaddubsw   m5,        [r3 + 15 * 16]             ; [31]
    pmulhrsw    m5,        m7
    palignr     m6,        m2, m0, 4
    pmaddubsw   m6,        [r3 + 4 * 16]              ; [ 20]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6
    palignr     m1,        m2, m0, 6
    pmaddubsw   m6,        m1, [r3 - 7 * 16]          ; [ 9]
    pmulhrsw    m6,        m7
    pmaddubsw   m1,        [r3 + 14 * 16]             ; [30]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1
    palignr     m1,        m2, m0, 8
    pmaddubsw   m1,        [r3 + 3 * 16]              ; [19]
    pmulhrsw    m1,        m7
    palignr     m2,        m0, 10
    pmaddubsw   m3,        m2, [r3 - 8 * 16]          ; [8]
    pmulhrsw    m3,        m7
    packuswb    m1,        m3

    TRANSPOSE_STORE_8x8 0, %1, m4, m5, m6, m1

    pmaddubsw   m4,        m2, [r3 + 13 * 16]         ; [29]
    pmulhrsw    m4,        m7
    movu        m0,        [r2 + 6]
    palignr     m1,        m0, 1
    punpckhbw   m2,        m0, m1
    punpcklbw   m0,        m1
    palignr     m1,        m2, m0, 2
    pmaddubsw   m1,        [r3 +  2 * 16]             ; [18]
    pmulhrsw    m1,        m7
    packuswb    m4,        m1
    palignr     m5,        m2, m0, 4
    mova        m6,        m5
    pmaddubsw   m5,        [r3 - 9 * 16]              ; [07]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        [r3 + 12 * 16]             ; [28]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6
    palignr     m6,        m2, m0, 6
    pmaddubsw   m6,        [r3 +      16]             ; [17]
    pmulhrsw    m6,        m7
    palignr     m1,        m2, m0, 8
    pmaddubsw   m3,        m1, [r3 - 10 * 16]         ; [06]
    pmulhrsw    m3,        m7
    packuswb    m6,        m3
    pmaddubsw   m1,        [r3 + 11 * 16]             ; [27]
    pmulhrsw    m1,        m7
    palignr     m2,        m0, 10
    pmaddubsw   m2,        [r3]                       ; [16]
    pmulhrsw    m2,        m7
    packuswb    m1,        m2

    TRANSPOSE_STORE_8x8 1, %1, m4, m5, m6, m1

    movu        m0,        [r2 + 12]
    palignr     m1,        m0, 1
    punpckhbw   m2,        m0, m1
    punpcklbw   m0,        m1
    mova        m1,        m0
    pmaddubsw   m4,        m0, [r3 - 11 * 16]         ; [5]
    pmulhrsw    m4,        m7
    pmaddubsw   m1,        [r3 + 10 * 16]             ; [26]
    pmulhrsw    m1,        m7
    packuswb    m4,        m1
    palignr     m5,        m2, m0, 2
    pmaddubsw   m5,        [r3 - 16]                  ; [15]
    pmulhrsw    m5,        m7
    palignr     m6,        m2, m0, 4
    mova        m1,        m6
    pmaddubsw   m1,        [r3 - 12 * 16]             ; [4]
    pmulhrsw    m1,        m7
    packuswb    m5,        m1
    pmaddubsw   m6,        [r3 + 9 * 16]              ; [25]
    pmulhrsw    m6,        m7
    palignr     m1,        m2, m0, 6
    pmaddubsw   m1,        [r3 - 2 * 16]              ; [14]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1
    palignr     m1,        m2, m0, 8
    mova        m2,        m1
    pmaddubsw   m1,        [r3 - 13 * 16]             ; [3]
    pmulhrsw    m1,        m7
    pmaddubsw   m2,        [r3 + 8 * 16]              ; [24]
    pmulhrsw    m2,        m7
    packuswb    m1,        m2

    TRANSPOSE_STORE_8x8 2, %1, m4, m5, m6, m1

    movu        m0,        [r2 + 17]
    palignr     m1,        m0, 1
    punpckhbw   m2,        m0, m1
    punpcklbw   m0,        m1
    pmaddubsw   m4,        m0, [r3 - 3 * 16]          ; [13]
    pmulhrsw    m4,        m7
    palignr     m5,        m2, m0, 2
    pmaddubsw   m1,        m5, [r3 - 14 * 16]         ; [2]
    pmulhrsw    m1,        m7
    packuswb    m4,        m1
    pmaddubsw   m5,        [r3 + 7 * 16]              ; [23]
    pmulhrsw    m5,        m7
    palignr     m6,        m2, m0, 4
    pmaddubsw   m6,        [r3 - 4 * 16]              ; [12]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6
    palignr     m6,        m2, m0, 6
    mova        m1,        m6
    pmaddubsw   m6,        [r3 - 15 * 16]             ; [1]
    pmulhrsw    m6,        m7
    pmaddubsw   m1,        [r3 + 6 * 16]              ; [22]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1
    palignr     m1,        m2, m0, 8
    pmaddubsw   m1,        [r3 - 5 * 16]              ; [11]
    pmulhrsw    m1,        m7
    packuswb    m1,        m1
    movhps      m1,        [r2 + 22]                  ; [00]

    TRANSPOSE_STORE_8x8 3, %1, m4, m5, m6, m1
%endmacro

%macro MODE_5_31 1
    movu        m0,        [r2 + 1]
    palignr     m1,        m0, 1
    punpckhbw   m2,        m0, m1
    punpcklbw   m0,        m1
    palignr     m1,        m2, m0, 2
    mova        m5,        m1
    pmaddubsw   m4,        m0, [r3 +      16]          ; [17]
    pmulhrsw    m4,        m7
    pmaddubsw   m1,        [r3 - 14 * 16]              ; [2]
    pmulhrsw    m1,        m7
    packuswb    m4,        m1
    pmaddubsw   m5,        [r3 + 3 * 16]               ; [19]
    pmulhrsw    m5,        m7
    palignr     m6,        m2, m0, 4
    mova        m1,        m6
    pmaddubsw   m6,        [r3 - 12 * 16]              ; [4]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6
    pmaddubsw   m6,        m1, [r3 + 5 * 16]               ; [21]
    pmulhrsw    m6,        m7
    palignr     m1,        m2, m0, 6
    mova        m3,        m1
    pmaddubsw   m3,        [r3 - 10 * 16]              ; [6]
    pmulhrsw    m3,        m7
    packuswb    m6,        m3
    pmaddubsw   m1,        [r3 + 7 * 16]               ; [23]
    pmulhrsw    m1,        m7
    palignr     m2,        m0, 8
    pmaddubsw   m2,        [r3 - 8 * 16]               ; [8]
    pmulhrsw    m2,        m7
    packuswb    m1,        m2

    TRANSPOSE_STORE_8x8 0, %1, m4, m5, m6, m1

    movu        m0,        [r2 + 5]
    palignr     m1,        m0, 1
    punpckhbw   m2,        m0, m1
    punpcklbw   m0,        m1
    palignr     m1,        m2, m0, 2
    mova        m5,        m1
    pmaddubsw   m4,        m0, [r3 + 9 * 16]           ; [25]
    pmulhrsw    m4,        m7
    pmaddubsw   m1,        [r3 - 6 * 16]               ; [10]
    pmulhrsw    m1,        m7
    packuswb    m4,        m1
    pmaddubsw   m5,        [r3 + 11 * 16]              ; [27]
    pmulhrsw    m5,        m7
    palignr     m6,        m2, m0, 4
    mova        m1,        m6
    pmaddubsw   m6,        [r3 - 4 * 16]               ; [12]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6
    pmaddubsw   m6,        m1, [r3 + 13 * 16]          ; [29]
    pmulhrsw    m6,        m7
    palignr     m1,        m2, m0, 6
    mova        m3,        m1
    pmaddubsw   m3,        [r3 - 2 * 16]               ; [14]
    pmulhrsw    m3,        m7
    packuswb    m6,        m3
    pmaddubsw   m1,        [r3 + 15 * 16]              ; [31]
    pmulhrsw    m1,        m7
    palignr     m2,        m0, 8
    pmaddubsw   m2,        [r3]                        ; [16]
    pmulhrsw    m2,        m7
    packuswb    m1,        m2

    TRANSPOSE_STORE_8x8 1, %1, m4, m5, m6, m1

    movu        m0,        [r2 + 10]
    palignr     m1,        m0, 1
    punpckhbw   m2,        m0, m1
    punpcklbw   m0,        m1
    mova        m1,        m0
    pmaddubsw   m4,        m0, [r3 - 15 * 16]          ; [1]
    pmulhrsw    m4,        m7
    pmaddubsw   m1,        [r3 + 2 * 16]               ; [18]
    pmulhrsw    m1,        m7
    packuswb    m4,        m1
    palignr     m5,        m2, m0, 2
    mova        m1,        m5
    pmaddubsw   m5,        [r3 - 13 * 16]              ; [3]
    pmulhrsw    m5,        m7
    pmaddubsw   m1,        [r3 + 4 * 16]               ; [20]
    pmulhrsw    m1,        m7
    packuswb    m5,        m1
    palignr     m1,        m2, m0, 4
    pmaddubsw   m6,        m1, [r3 - 11 * 16]          ; [5]
    pmulhrsw    m6,        m7
    pmaddubsw   m1,        [r3 + 6 * 16]               ; [22]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1
    palignr     m2,        m0, 6
    pmaddubsw   m1,        m2, [r3 - 9 * 16]           ; [7]
    pmulhrsw    m1,        m7
    pmaddubsw   m2,        [r3 + 8 * 16]               ; [24]
    pmulhrsw    m2,        m7
    packuswb    m1,        m2

    TRANSPOSE_STORE_8x8 2, %1, m4, m5, m6, m1

    movu        m0,        [r2 + 14]
    palignr     m1,        m0, 1
    punpckhbw   m2,        m0, m1
    punpcklbw   m0,        m1
    mova        m1,        m0
    pmaddubsw   m4,        m0, [r3 - 7 * 16]           ; [9]
    pmulhrsw    m4,        m7
    pmaddubsw   m1,        [r3 + 10 * 16]              ; [26]
    pmulhrsw    m1,        m7
    packuswb    m4,        m1
    palignr     m5,        m2, m0, 2
    mova        m1,        m5
    pmaddubsw   m5,        [r3 - 5 * 16]               ; [11]
    pmulhrsw    m5,        m7
    pmaddubsw   m1,        [r3 + 12 * 16]              ; [28]
    pmulhrsw    m1,        m7
    packuswb    m5,        m1
    palignr     m1,        m2, m0, 4
    pmaddubsw   m6,        m1, [r3 - 3 * 16]           ; [13]
    pmulhrsw    m6,        m7
    pmaddubsw   m1,        [r3 + 14 * 16]              ; [30]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1
    palignr     m2,        m0, 6
    pmaddubsw   m1,        m2, [r3 - 16]               ; [15]
    pmulhrsw    m1,        m7
    packuswb    m1,        m1
    movhps      m1,        [r2 + 18]                   ; [00]

    TRANSPOSE_STORE_8x8 3, %1, m4, m5, m6, m1
%endmacro

%macro MODE_6_30 1
    movu        m0,        [r2 + 1]
    palignr     m1,        m0, 1
    punpckhbw   m2,        m0, m1
    punpcklbw   m0,        m1
    mova        m1,        m0
    pmaddubsw   m4,        m0, [r3 - 3 * 16]          ; [13]
    pmulhrsw    m4,        m7
    pmaddubsw   m1,        [r3 + 10 * 16]             ; [26]
    pmulhrsw    m1,        m7
    packuswb    m4,        m1
    palignr     m6,        m2, m0, 2
    pmaddubsw   m5,        m6, [r3 - 9 * 16]          ; [7]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        [r3 + 4 * 16]              ; [20]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6
    palignr     m1,        m2, m0, 4
    pmaddubsw   m6,        m1, [r3 - 15 * 16]         ; [1]
    pmulhrsw    m6,        m7
    pmaddubsw   m3,        m1, [r3 - 2 * 16]          ; [14]
    pmulhrsw    m3,        m7
    packuswb    m6,        m3
    pmaddubsw   m1,        [r3 + 11 * 16]             ; [27]
    pmulhrsw    m1,        m7
    palignr     m2,        m0, 6
    pmaddubsw   m3,        m2, [r3 - 8 * 16]          ; [8]
    pmulhrsw    m3,        m7
    packuswb    m1,        m3

    TRANSPOSE_STORE_8x8 0, %1, m4, m5, m6, m1

    pmaddubsw   m4,        m2, [r3 +  5 * 16]         ; [21]
    pmulhrsw    m4,        m7
    movu        m0,        [r2 + 5]
    palignr     m1,        m0, 1
    punpckhbw   m2,        m0, m1
    punpcklbw   m0,        m1
    mova        m6,        m0
    pmaddubsw   m1,        m6, [r3 - 14 * 16]         ; [2]
    pmulhrsw    m1,        m7
    packuswb    m4,        m1
    pmaddubsw   m5,        m6, [r3 - 16]              ; [15]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        [r3 + 12 * 16]             ; [28]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6
    palignr     m3,        m2, m0, 2
    pmaddubsw   m6,        m3, [r3 - 7 * 16]          ; [9]
    pmulhrsw    m6,        m7
    pmaddubsw   m3,        [r3 + 6 * 16]              ; [22]
    pmulhrsw    m3,        m7
    packuswb    m6,        m3
    palignr     m2,        m0, 4
    pmaddubsw   m1,        m2, [r3 - 13 * 16]         ; [3]
    pmulhrsw    m1,        m7
    pmaddubsw   m3,        m2, [r3]                   ; [16]
    pmulhrsw    m3,        m7
    packuswb    m1,        m3

    TRANSPOSE_STORE_8x8 1, %1, m4, m5, m6, m1

    pmaddubsw   m4,        m2, [r3 +  13 * 16]        ; [29]
    pmulhrsw    m4,        m7
    movu        m0,        [r2 + 7]
    palignr     m1,        m0, 1
    punpckhbw   m2,        m0, m1
    punpcklbw   m0,        m1
    palignr     m5,        m2, m0, 2
    pmaddubsw   m1,        m5, [r3 - 6 * 16]          ; [10]
    pmulhrsw    m1,        m7
    packuswb    m4,        m1
    pmaddubsw   m5,        [r3 + 7 * 16]              ; [23]
    pmulhrsw    m5,        m7
    palignr     m1,        m2, m0, 4
    pmaddubsw   m6,        m1, [r3 - 12 * 16]         ; [4]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6
    pmaddubsw   m6,        m1, [r3 + 16]              ; [17]
    pmulhrsw    m6,        m7
    pmaddubsw   m1,        [r3 + 14 * 16]             ; [30]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1
    palignr     m2,        m2, m0, 6
    pmaddubsw   m1,        m2, [r3 - 5 * 16]          ; [11]
    pmulhrsw    m1,        m7
    pmaddubsw   m2,        m2, [r3 + 8 * 16]          ; [24]
    pmulhrsw    m2,        m7
    packuswb    m1,        m2

    TRANSPOSE_STORE_8x8 2, %1, m4, m5, m6, m1

    movu        m0,        [r2 + 11]
    palignr     m1,        m0, 1
    punpckhbw   m2,        m0, m1
    punpcklbw   m0,        m1
    mova        m5,        m0
    pmaddubsw   m4,        m0, [r3 - 11 * 16]         ; [5]
    pmulhrsw    m4,        m7
    pmaddubsw   m3,        m5, [r3 + 2 * 16]          ; [18]
    pmulhrsw    m3,        m7
    packuswb    m4,        m3
    pmaddubsw   m5,        [r3 + 15 * 16]             ; [31]
    pmulhrsw    m5,        m7
    palignr     m6,        m2, m0, 2
    pmaddubsw   m1,        m6, [r3 - 4 * 16]          ; [12]
    pmulhrsw    m1,        m7
    packuswb    m5,        m1
    pmaddubsw   m6,        [r3 + 9 * 16]              ; [25]
    pmulhrsw    m6,        m7
    palignr     m1,        m2, m0, 4
    pmaddubsw   m2,        m1, [r3 - 10 * 16]         ; [6]
    pmulhrsw    m2,        m7
    packuswb    m6,        m2
    pmaddubsw   m1,        [r3 + 3 * 16]              ; [19]
    pmulhrsw    m1,        m7
    packuswb    m1,        m1
    movhps      m1,        [r2 + 14]                  ; [00]

    TRANSPOSE_STORE_8x8 3, %1, m4, m5, m6, m1
%endmacro

%macro MODE_7_29 1
    movu        m0,        [r2 + 1]
    palignr     m1,        m0, 1
    punpckhbw   m2,        m0, m1
    punpcklbw   m0,        m1
    mova        m5,        m0
    pmaddubsw   m4,        m0, [r3 - 7 * 16]         ; [9]
    pmulhrsw    m4,        m7
    pmaddubsw   m3,        m5, [r3 + 2 * 16]         ; [18]
    pmulhrsw    m3,        m7
    packuswb    m4,        m3
    pmaddubsw   m5,        [r3 + 11 * 16]            ; [27]
    pmulhrsw    m5,        m7
    palignr     m1,        m2, m0, 2
    palignr     m2,        m0, 4
    pmaddubsw   m6,        m1, [r3 - 12 * 16]        ; [4]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6
    pmaddubsw   m6,        m1, [r3 - 3 * 16]         ; [13]
    pmulhrsw    m6,        m7
    pmaddubsw   m0,        m1, [r3 + 6 * 16]         ; [22]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0
    pmaddubsw   m1,        [r3 + 15 * 16]            ; [31]
    pmulhrsw    m1,        m7
    pmaddubsw   m0,        m2, [r3 - 8 * 16]         ; [8]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0

    TRANSPOSE_STORE_8x8 0, %1, m4, m5, m6, m1

    pmaddubsw   m4,        m2, [r3 + 16]             ; [17]
    pmulhrsw    m4,        m7
    pmaddubsw   m2,        [r3 + 10 * 16]            ; [26]
    pmulhrsw    m2,        m7
    packuswb    m4,        m2
    movu        m0,        [r2 + 4]
    palignr     m1,        m0, 1
    punpckhbw   m2,        m0, m1
    punpcklbw   m0,        m1
    palignr     m2,        m0, 2
    pmaddubsw   m5,        m0, [r3 - 13 * 16]        ; [03]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m0, [r3 - 4 * 16]         ; [12]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6
    pmaddubsw   m6,        m0, [r3 + 5 * 16]         ; [21]
    pmulhrsw    m6,        m7
    pmaddubsw   m0,        [r3 + 14 * 16]            ; [30]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0
    pmaddubsw   m1,        m2, [r3 - 9 * 16]         ; [07]
    pmulhrsw    m1,        m7
    pmaddubsw   m3,        m2, [r3]                  ; [16]
    pmulhrsw    m3,        m7
    packuswb    m1,        m3

    TRANSPOSE_STORE_8x8 1, %1, m4, m5, m6, m1

    pmaddubsw   m4,        m2, [r3 + 9 * 16]         ; [25]
    pmulhrsw    m4,        m7
    movu        m0,        [r2 + 6]
    palignr     m1,        m0, 1
    punpckhbw   m2,        m0, m1
    punpcklbw   m0,        m1
    palignr     m2,        m0, 2
    pmaddubsw   m1,        m0, [r3 - 14 * 16]        ; [2]
    pmulhrsw    m1,        m7
    packuswb    m4,        m1
    pmaddubsw   m5,        m0, [r3 - 5 * 16]         ; [11]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m0, [r3 + 4 * 16]         ; [20]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6
    pmaddubsw   m6,        m0, [r3 + 13 * 16]        ; [29]
    pmulhrsw    m6,        m7
    pmaddubsw   m1,        m2, [r3 - 10 * 16]        ; [6]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1
    pmaddubsw   m1,        m2, [r3 - 16]             ; [15]
    pmulhrsw    m1,        m7
    pmaddubsw   m2,        m2, [r3 + 8 * 16]         ; [24]
    pmulhrsw    m2,        m7
    packuswb    m1,        m2

    TRANSPOSE_STORE_8x8 2, %1, m4, m5, m6, m1

    movu        m0,        [r2 + 8]
    palignr     m1,        m0, 1
    punpckhbw   m2,        m0, m1
    punpcklbw   m0,        m1
    pmaddubsw   m4,        m0, [r3 - 15 * 16]        ; [1]
    pmulhrsw    m4,        m7
    pmaddubsw   m3,        m0, [r3 - 6 * 16]         ; [10]
    pmulhrsw    m3,        m7
    packuswb    m4,        m3
    pmaddubsw   m5,        m0, [r3 + 3 * 16]         ; [19]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m0, [r3 + 12 * 16]        ; [28]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6
    palignr     m2,        m0, 2
    pmaddubsw   m6,        m2, [r3 - 11 * 16]        ; [5]
    pmulhrsw    m6,        m7
    pmaddubsw   m0,        m2, [r3 - 2 * 16]         ; [14]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0
    pmaddubsw   m1,        m2, [r3 + 7 * 16]         ; [23]
    pmulhrsw    m1,        m7
    packuswb    m1,        m1
    movhps      m1,        [r2 + 10]                 ; [0]

    TRANSPOSE_STORE_8x8 3, %1, m4, m5, m6, m1
%endmacro

%macro MODE_8_28 1
    movu        m0,        [r2 + 1]
    palignr     m1,        m0, 1
    punpckhbw   m2,        m0, m1
    punpcklbw   m0,        m1
    palignr     m2,        m0, 2
    pmaddubsw   m4,        m0, [r3 - 11 * 16]     ; [5]
    pmulhrsw    m4,        m7
    pmaddubsw   m3,        m0, [r3 - 6 * 16]      ; [10]
    pmulhrsw    m3,        m7
    packuswb    m4,        m3
    pmaddubsw   m5,        m0, [r3 - 1 * 16]      ; [15]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m0, [r3 + 4 * 16]      ; [20]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6
    pmaddubsw   m6,        m0, [r3 + 9 * 16]      ; [25]
    pmulhrsw    m6,        m7
    pmaddubsw   m0,        [r3 + 14 * 16]         ; [30]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0
    pmaddubsw   m1,        m2, [r3 - 13 * 16]     ; [3]
    pmulhrsw    m1,        m7
    pmaddubsw   m0,        m2, [r3 - 8 * 16]      ; [8]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0

    TRANSPOSE_STORE_8x8 0, %1, m4, m5, m6, m1

    pmaddubsw   m4,        m2, [r3 - 3 * 16]      ; [13]
    pmulhrsw    m4,        m7
    pmaddubsw   m5,        m2, [r3 + 2 * 16]      ; [18]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5
    pmaddubsw   m5,        m2, [r3 + 7 * 16]      ; [23]
    pmulhrsw    m5,        m7
    pmaddubsw   m2,        [r3 + 12 * 16]         ; [28]
    pmulhrsw    m2,        m7
    packuswb    m5,        m2
    movu        m0,        [r2 + 3]
    palignr     m1,        m0, 1
    punpckhbw   m2,        m0, m1
    punpcklbw   m0,        m1
    pmaddubsw   m6,        m0, [r3 - 15 * 16]     ; [01]
    pmulhrsw    m6,        m7
    pmaddubsw   m1,        m0, [r3 - 10 * 16]     ; [06]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1
    pmaddubsw   m1,        m0, [r3 - 5 * 16]      ; [11]
    pmulhrsw    m1,        m7
    mova        m2,        m0
    pmaddubsw   m0,        [r3]                   ; [16]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0

    TRANSPOSE_STORE_8x8 1, %1, m4, m5, m6, m1

    pmaddubsw   m4,        m2, [r3 + 5 * 16]      ; [21]
    pmulhrsw    m4,        m7
    pmaddubsw   m5,        m2, [r3 + 10 * 16]     ; [26]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5
    pmaddubsw   m5,        m2, [r3 + 15 * 16]     ; [31]
    pmulhrsw    m5,        m7
    movu        m0,        [r2 + 4]
    palignr     m1,        m0, 1
    punpckhbw   m2,        m0, m1
    punpcklbw   m0,        m1
    pmaddubsw   m2,        m0, [r3 - 12 * 16]     ; [4]
    pmulhrsw    m2,        m7
    packuswb    m5,        m2
    pmaddubsw   m6,        m0, [r3 - 7 * 16]      ; [9]
    pmulhrsw    m6,        m7
    pmaddubsw   m1,        m0, [r3 - 2 * 16]      ; [14]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1
    pmaddubsw   m1,        m0, [r3 + 3 * 16]      ; [19]
    pmulhrsw    m1,        m7
    mova        m2,        m0
    pmaddubsw   m0,        [r3 + 8 * 16]          ; [24]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0

    TRANSPOSE_STORE_8x8 2, %1, m4, m5, m6, m1

    pmaddubsw   m4,        m2, [r3 + 13 * 16]     ; [29]
    pmulhrsw    m4,        m7
    movu        m0,        [r2 + 5]
    palignr     m1,        m0, 1
    punpckhbw   m2,        m0, m1
    punpcklbw   m0,        m1
    pmaddubsw   m1,        m0, [r3 - 14 * 16]     ; [2]
    pmulhrsw    m1,        m7
    packuswb    m4,        m1
    pmaddubsw   m5,        m0, [r3 - 9 * 16]      ; [7]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m0, [r3 - 4 * 16]      ; [12]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6
    pmaddubsw   m6,        m0, [r3 + 16]          ; [17]
    pmulhrsw    m6,        m7
    pmaddubsw   m1,        m0, [r3 + 6 * 16]      ; [22]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1
    pmaddubsw   m1,        m0, [r3 + 11 * 16]         ; [27]
    pmulhrsw    m1,        m7
    packuswb    m1,        m1
    movhps      m1,        [r2 + 6]               ; [00]

    TRANSPOSE_STORE_8x8 3, %1, m4, m5, m6, m1
%endmacro

%macro MODE_9_27 1
    movu        m2,        [r2 + 1]
    palignr     m1,        m2, 1
    punpckhbw   m0,        m2, m1
    punpcklbw   m2,        m1
    pmaddubsw   m4,        m2, [r3 - 14 * 16]   ; [2]
    pmulhrsw    m4,        m7
    pmaddubsw   m3,        m2, [r3 - 12 * 16]   ; [4]
    pmulhrsw    m3,        m7
    packuswb    m4,        m3
    pmaddubsw   m5,        m2, [r3 - 10 * 16]   ; [6]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m2, [r3 - 8 * 16]    ; [8]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6
    pmaddubsw   m6,        m2, [r3 - 6 * 16]    ; [10]
    pmulhrsw    m6,        m7
    pmaddubsw   m3,        m2, [r3 - 4 * 16]    ; [12]
    pmulhrsw    m3,        m7
    packuswb    m6,        m3
    pmaddubsw   m1,        m2, [r3 - 2 * 16]    ; [14]
    pmulhrsw    m1,        m7
    pmaddubsw   m0,        m2, [r3]             ; [16]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0

    TRANSPOSE_STORE_8x8 0, %1, m4, m5, m6, m1

    pmaddubsw   m4,        m2, [r3 + 2 * 16]    ; [18]
    pmulhrsw    m4,        m7
    pmaddubsw   m5,        m2, [r3 + 4 * 16]    ; [20]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5
    pmaddubsw   m5,        m2, [r3 + 6 * 16]    ; [22]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m2, [r3 + 8 * 16]    ; [24]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6
    pmaddubsw   m6,        m2, [r3 + 10 * 16]   ; [26]
    pmulhrsw    m6,        m7
    pmaddubsw   m1,        m2, [r3 + 12 * 16]   ; [28]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1
    pmaddubsw   m1,        m2, [r3 + 14 * 16]   ; [30]
    pmulhrsw    m1,        m7
    packuswb    m1,        m1
    movhps      m1,        [r2 + 2]             ; [00]

    TRANSPOSE_STORE_8x8 1, %1, m4, m5, m6, m1

    movu        m2,        [r2 + 2]
    palignr     m1,        m2, 1
    punpcklbw   m2,        m1
    pmaddubsw   m4,        m2, [r3 - 14 * 16]   ; [2]
    pmulhrsw    m4,        m7
    pmaddubsw   m3,        m2, [r3 - 12 * 16]   ; [4]
    pmulhrsw    m3,        m7
    packuswb    m4,        m3
    pmaddubsw   m5,        m2, [r3 - 10 * 16]   ; [6]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m2, [r3 - 8 * 16]    ; [8]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6
    pmaddubsw   m6,        m2, [r3 - 6 * 16]    ; [10]
    pmulhrsw    m6,        m7
    pmaddubsw   m0,        m2, [r3 - 4 * 16]    ; [12]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0
    pmaddubsw   m1,        m2, [r3 - 2 * 16]    ; [14]
    pmulhrsw    m1,        m7
    pmaddubsw   m0,        m2, [r3]             ; [16]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0

    TRANSPOSE_STORE_8x8 2, %1, m4, m5, m6, m1

    movu        m2,        [r2 + 2]
    palignr     m1,        m2, 1
    punpcklbw   m2,        m1
    pmaddubsw   m4,        m2, [r3 + 2 * 16]    ; [18]
    pmulhrsw    m4,        m7
    pmaddubsw   m5,        m2, [r3 + 4 * 16]    ; [20]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5
    pmaddubsw   m5,        m2, [r3 + 6 * 16]    ; [22]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m2, [r3 + 8 * 16]    ; [24]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6
    pmaddubsw   m6,        m2, [r3 + 10 * 16]   ; [26]
    pmulhrsw    m6,        m7
    pmaddubsw   m1,        m2, [r3 + 12 * 16]   ; [28]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1
    pmaddubsw   m1,        m2, [r3 + 14 * 16]   ; [30]
    pmulhrsw    m1,        m7
    packuswb    m1,        m1
    movhps      m1,        [r2 + 3]             ; [00]

     TRANSPOSE_STORE_8x8 3, %1, m4, m5, m6, m1
%endmacro

%macro MODE_12_24 1
    movu        m2,        [r2]
    palignr     m1,        m2, 1
    punpckhbw   m0,        m2, m1
    punpcklbw   m2,        m1
    palignr     m0,        m2, 2
    pmaddubsw   m4,        m0, [r4 + 11 * 16]         ; [27]
    pmulhrsw    m4,        m7
    pmaddubsw   m3,        m0, [r4 + 6 * 16]          ; [22]
    pmulhrsw    m3,        m7
    packuswb    m4,        m3
    pmaddubsw   m5,        m0, [r4 + 16]              ; [17]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m0, [r4 - 4 * 16]          ; [12]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6
    pmaddubsw   m6,        m0, [r4 - 9 * 16]          ; [7]
    pmulhrsw    m6,        m7
    pmaddubsw   m3,        m0, [r4 - 14 * 16]         ; [2]
    pmulhrsw    m3,        m7
    packuswb    m6,        m3
    pmaddubsw   m1,        m2, [r4 + 13 * 16]         ; [29]
    pmulhrsw    m1,        m7
    pmaddubsw   m3,        m2, [r4 + 8 * 16]          ; [24]
    pmulhrsw    m3,        m7
    packuswb    m1,        m3
    TRANSPOSE_STORE_8x8 0, %1, m4, m5, m6, m1
    pmaddubsw   m4,        m2, [r4 + 3 * 16]          ; [19]
    pmulhrsw    m4,        m7
    pmaddubsw   m5,        m2, [r4 - 2 * 16]          ; [14]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5
    pmaddubsw   m5,        m2, [r4 - 7 * 16]          ; [09]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m2, [r4 - 12 * 16]         ; [04]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6
    movu        m0,        [r2 - 2]
    palignr     m1,        m0, 1
    punpckhbw   m2,        m0, m1
    punpcklbw   m0,        m1
    palignr     m2,        m0, 2
    pmaddubsw   m6,        m2, [r4 + 15 * 16]         ; [31]
    pmulhrsw    m6,        m7
    pmaddubsw   m1,        m2, [r4 + 10 * 16]         ; [26]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1
    pmaddubsw   m1,        m2, [r4 + 5 * 16]          ; [21]
    pmulhrsw    m1,        m7
    pmaddubsw   m3,        m2, [r4]                   ; [16]
    pmulhrsw    m3,        m7
    packuswb    m1,        m3
    TRANSPOSE_STORE_8x8 1, %1, m4, m5, m6, m1
    pmaddubsw   m4,        m2, [r4 - 5 * 16]          ; [11]
    pmulhrsw    m4,        m7
    pmaddubsw   m3,        m2, [r4 - 10 * 16]         ; [06]
    pmulhrsw    m3,        m7
    packuswb    m4,        m3
    pmaddubsw   m5,        m2, [r4 - 15 * 16]         ; [1]
    pmulhrsw    m5,        m7
    movu        m0,        [r2 - 3]
    palignr     m1,        m0, 1
    punpckhbw   m2,        m0, m1
    punpcklbw   m0,        m1
    palignr     m2,        m0, 2
    pmaddubsw   m6,        m2, [r4 + 12 * 16]         ; [28]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6
    pmaddubsw   m6,        m2, [r4 + 7 * 16]          ; [23]
    pmulhrsw    m6,        m7
    pmaddubsw   m3,        m2, [r4 + 2 * 16]          ; [18]
    pmulhrsw    m3,        m7
    packuswb    m6,        m3
    pmaddubsw   m1,        m2, [r4 - 3 * 16]          ; [13]
    pmulhrsw    m1,        m7
    pmaddubsw   m3,        m2, [r4 - 8 * 16]          ; [8]
    pmulhrsw    m3,        m7
    packuswb    m1,        m3
    TRANSPOSE_STORE_8x8 2, %1, m4, m5, m6, m1
    pmaddubsw   m4,        m2, [r4 - 13 * 16]         ; [3]
    pmulhrsw    m4,        m7
    movu        m2,        [r2 - 4]
    palignr     m1,        m2, 1
    punpckhbw   m0,        m2, m1
    punpcklbw   m2,        m1
    palignr     m0,        m2, 2
    pmaddubsw   m5,        m0, [r4 + 14 * 16]         ; [30]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5
    pmaddubsw   m5,        m0, [r4 + 9 * 16]          ; [25]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m0, [r4 + 4 * 16]          ; [20]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6
    pmaddubsw   m6,        m0, [r4 - 16]              ; [15]
    pmulhrsw    m6,        m7
    pmaddubsw   m1,        m0, [r4 - 6 * 16]          ; [10]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1
    pmaddubsw   m1,        m0, [r4 - 11 * 16]         ; [05]
    pmulhrsw    m1,        m7
    movu        m2,        [pb_fact0]
    pshufb      m0,        m2
    pmovzxbw    m0,        m0
    packuswb    m1,        m0
    TRANSPOSE_STORE_8x8 3, %1, m4, m5, m6, m1
%endmacro

;------------------------------------------------------------------------------------------
; void intraPredAng32(pixel* dst, intptr_t dstStride, pixel* src, int dirMode, int bFilter)
;------------------------------------------------------------------------------------------
INIT_XMM ssse3
cglobal intra_pred_ang32_2, 3,5,4
    lea             r4, [r2]
    add             r2, 64
    cmp             r3m, byte 34
    cmove           r2, r4
    movu            m0, [r2 + 2]
    movu            m1, [r2 + 18]
    movu            m3, [r2 + 34]

    lea             r3, [r1 * 3]

    movu            [r0], m0
    movu            [r0 + 16], m1
    palignr         m2, m1, m0, 1
    movu            [r0 + r1], m2
    palignr         m2, m3, m1, 1
    movu            [r0 + r1 + 16], m2
    palignr         m2, m1, m0, 2
    movu            [r0 + r1 * 2], m2
    palignr         m2, m3, m1, 2
    movu            [r0 + r1 * 2 + 16], m2
    palignr         m2, m1, m0, 3
    movu            [r0 + r3], m2
    palignr         m2, m3, m1, 3
    movu            [r0 + r3 + 16], m2

    lea             r0, [r0 + r1 * 4]

    palignr         m2, m1, m0, 4
    movu            [r0], m2
    palignr         m2, m3, m1, 4
    movu            [r0 + 16], m2
    palignr         m2, m1, m0, 5
    movu            [r0 + r1], m2
    palignr         m2, m3, m1, 5
    movu            [r0 + r1 + 16], m2
    palignr         m2, m1, m0, 6
    movu            [r0 + r1 * 2], m2
    palignr         m2, m3, m1, 6
    movu            [r0 + r1 * 2 + 16], m2
    palignr         m2, m1, m0, 7
    movu            [r0 + r3], m2
    palignr         m2, m3, m1, 7
    movu            [r0 + r3 + 16], m2

    lea             r0, [r0 + r1 * 4]

    palignr         m2, m1, m0, 8
    movu            [r0], m2
    palignr         m2, m3, m1, 8
    movu            [r0 + 16], m2
    palignr         m2, m1, m0, 9
    movu            [r0 + r1], m2
    palignr         m2, m3, m1, 9
    movu            [r0 + r1 + 16], m2
    palignr         m2, m1, m0, 10
    movu            [r0 + r1 * 2], m2
    palignr         m2, m3, m1, 10
    movu            [r0 + r1 * 2 + 16], m2
    palignr         m2, m1, m0, 11
    movu            [r0 + r3], m2
    palignr         m2, m3, m1, 11
    movu            [r0 + r3 + 16], m2

    lea             r0, [r0 + r1 * 4]

    palignr         m2, m1, m0, 12
    movu            [r0], m2
    palignr         m2, m3, m1, 12
    movu            [r0 + 16], m2
    palignr         m2, m1, m0, 13
    movu            [r0 + r1], m2
    palignr         m2, m3, m1, 13
    movu            [r0 + r1 + 16], m2
    palignr         m2, m1, m0, 14
    movu            [r0 + r1 * 2], m2
    palignr         m2, m3, m1, 14
    movu            [r0 + r1 * 2 + 16], m2
    palignr         m2, m1, m0, 15
    movu            [r0 + r3], m2
    palignr         m2, m3, m1, 15
    movu            [r0 + r3 + 16], m2

    lea             r0, [r0 + r1 * 4]

    movu            [r0], m1
    movu            m0, [r2 + 50]
    movu            [r0 + 16], m3
    palignr         m2, m3, m1, 1
    movu            [r0 + r1], m2
    palignr         m2, m0, m3, 1
    movu            [r0 + r1 + 16], m2
    palignr         m2, m3, m1, 2
    movu            [r0 + r1 * 2], m2
    palignr         m2, m0, m3, 2
    movu            [r0 + r1 * 2 + 16], m2
    palignr         m2, m3, m1, 3
    movu            [r0 + r3], m2
    palignr         m2, m0, m3, 3
    movu            [r0 + r3 + 16], m2

    lea             r0, [r0 + r1 * 4]

    palignr         m2, m3, m1, 4
    movu            [r0], m2
    palignr         m2, m0, m3, 4
    movu            [r0 + 16], m2
    palignr         m2, m3, m1, 5
    movu            [r0 + r1], m2
    palignr         m2, m0, m3, 5
    movu            [r0 + r1 + 16], m2
    palignr         m2, m3, m1, 6
    movu            [r0 + r1 * 2], m2
    palignr         m2, m0, m3, 6
    movu            [r0 + r1 * 2 + 16], m2
    palignr         m2, m3, m1, 7
    movu            [r0 + r3], m2
    palignr         m2, m0, m3, 7
    movu            [r0 + r3 + 16], m2

    lea             r0, [r0 + r1 * 4]

    palignr         m2, m3, m1, 8
    movu            [r0], m2
    palignr         m2, m0, m3, 8
    movu            [r0 + 16], m2
    palignr         m2, m3, m1, 9
    movu            [r0 + r1], m2
    palignr         m2, m0, m3, 9
    movu            [r0 + r1 + 16], m2
    palignr         m2, m3, m1, 10
    movu            [r0 + r1 * 2], m2
    palignr         m2, m0, m3, 10
    movu            [r0 + r1 * 2 + 16], m2
    palignr         m2, m3, m1, 11
    movu            [r0 + r3], m2
    palignr         m2, m0, m3, 11
    movu            [r0 + r3 + 16], m2

    lea             r0, [r0 + r1 * 4]

    palignr         m2, m3, m1, 12
    movu            [r0], m2
    palignr         m2, m0, m3, 12
    movu            [r0 + 16], m2
    palignr         m2, m3, m1, 13
    movu            [r0 + r1], m2
    palignr         m2, m0, m3, 13
    movu            [r0 + r1 + 16], m2
    palignr         m2, m3, m1, 14
    movu            [r0 + r1 * 2], m2
    palignr         m2, m0, m3, 14
    movu            [r0 + r1 * 2 + 16], m2
    palignr         m2, m3, m1, 15
    movu            [r0 + r3], m2
    palignr         m2, m0, m3, 15
    movu            [r0 + r3 + 16], m2
    RET

INIT_XMM sse4
cglobal intra_pred_ang32_3, 3,7,8
    add         r2,        64
    lea         r3,        [ang_table + 16 * 16]
    mov         r4d,       4
    lea         r5,        [r1 * 3]                   ; r5 -> 3 * stride
    lea         r6,        [r0 + r1 * 4]              ; r6 -> 4 * stride
    mova        m7,        [pw_1024]
.loop:
    MODE_3_33 1
    lea         r0, [r6 + r1 * 4]
    lea         r6, [r6 + r1 * 8]
    add         r2, 8
    dec         r4
    jnz        .loop
    RET

INIT_XMM sse4
cglobal intra_pred_ang32_4, 3,7,8
    add         r2,        64
    lea         r3,        [ang_table + 16 * 16]
    mov         r4d,       4
    lea         r5,        [r1 * 3]                    ; r5 -> 3 * stride
    lea         r6,        [r0 + r1 * 4]               ; r6 -> 4 * stride
    mova        m7,        [pw_1024]
.loop:
    MODE_4_32 1
    lea         r0,        [r6 + r1 * 4]
    lea         r6,        [r6 + r1 * 8]
    add         r2,        8
    dec         r4
    jnz        .loop
    RET

INIT_XMM sse4
cglobal intra_pred_ang32_5, 3,7,8
    add         r2,        64
    lea         r3,        [ang_table + 16 * 16]
    mov         r4d,       4
    lea         r5,        [r1 * 3]                   ; r5 -> 3 * stride
    lea         r6,        [r0 + r1 * 4]              ; r6 -> 4 * stride
    mova        m7,        [pw_1024]
.loop:
    MODE_5_31 1
    lea         r0,        [r6 + r1 * 4]
    lea         r6,        [r6 + r1 * 8]
    add         r2,        8
    dec         r4
    jnz        .loop
    RET

INIT_XMM sse4
cglobal intra_pred_ang32_6, 3,7,8
    add         r2,        64
    lea         r3,        [ang_table + 16 * 16]
    mov         r4d,       4
    lea         r5,        [r1 * 3]                  ; r5 -> 3 * stride
    lea         r6,        [r0 + r1 * 4]             ; r6 -> 4 * stride
    mova        m7,        [pw_1024]
.loop:
    MODE_6_30 1
    lea         r0,        [r6 + r1 * 4]
    lea         r6,        [r6 + r1 * 8]
    add         r2,        8
    dec         r4
    jnz        .loop
    RET

INIT_XMM sse4
cglobal intra_pred_ang32_7, 3,7,8
    add         r2,        64
    lea         r3,        [ang_table + 16 * 16]
    mov         r4d,       4
    lea         r5,        [r1 * 3]               ; r5 -> 3 * stride
    lea         r6,        [r0 + r1 * 4]          ; r6 -> 4 * stride
    mova        m7,        [pw_1024]
.loop:
    MODE_7_29 1
    lea         r0,        [r6 + r1 * 4]
    lea         r6,        [r6 + r1 * 8]
    add         r2,        8
    dec         r4
    jnz        .loop
    RET

INIT_XMM sse4
cglobal intra_pred_ang32_8, 3,7,8
    add         r2,        64
    lea         r3,        [ang_table + 16 * 16]
    mov         r4d,       4
    lea         r5,        [r1 * 3]            ; r5 -> 3 * stride
    lea         r6,        [r0 + r1 * 4]       ; r6 -> 4 * stride
    mova        m7,        [pw_1024]
.loop:
    MODE_8_28 1
    lea         r0,        [r6 + r1 * 4]
    lea         r6,        [r6 + r1 * 8]
    add         r2,        8
    dec         r4
    jnz        .loop
    RET

INIT_XMM sse4
cglobal intra_pred_ang32_9, 3,7,8
    add         r2,        64
    lea         r3,        [ang_table + 16 * 16]
    mov         r4d,       4
    lea         r5,        [r1 * 3]         ; r5 -> 3 * stride
    lea         r6,        [r0 + r1 * 4]    ; r6 -> 4 * stride
    mova        m7,        [pw_1024]
.loop:
    MODE_9_27 1
    lea         r0,        [r6 + r1 * 4]
    lea         r6,        [r6 + r1 * 8]
    add         r2,        8
    dec         r4
    jnz        .loop
    RET

INIT_XMM sse4
cglobal intra_pred_ang32_10, 5,7,8,0-(2*mmsize)
%define m8 [rsp + 0 * mmsize]
%define m9 [rsp + 1 * mmsize]
    pxor        m7, m7
    mov         r6, 2
    movu        m0, [r2]
    movu        m1, [r2 + 1]
    mova        m8, m0
    mova        m9, m1
    mov         r3d, r4d
    lea         r4, [r1 * 3]

.loop:
    movu        m0, [r2 + 1 + 64]
    palignr     m1, m0, 1
    pshufb      m1, m7
    palignr     m2, m0, 2
    pshufb      m2, m7
    palignr     m3, m0, 3
    pshufb      m3, m7
    palignr     m4, m0, 4
    pshufb      m4, m7
    palignr     m5, m0, 5
    pshufb      m5, m7
    palignr     m6, m0, 6
    pshufb      m6, m7

    movu        [r0 + r1], m1
    movu        [r0 + r1 + 16], m1
    movu        [r0 + r1 * 2], m2
    movu        [r0 + r1 * 2 + 16], m2
    movu        [r0 + r4], m3
    movu        [r0 + r4 + 16], m3
    lea         r5, [r0 + r1 * 4]
    movu        [r5], m4
    movu        [r5 + 16], m4
    movu        [r5 + r1], m5
    movu        [r5 + r1 + 16], m5
    movu        [r5 + r1 * 2], m6
    movu        [r5 + r1 * 2 + 16], m6

    palignr     m1, m0, 7
    pshufb      m1, m7
    movhlps     m2, m0
    pshufb      m2, m7
    palignr     m3, m0, 9
    pshufb      m3, m7
    palignr     m4, m0, 10
    pshufb      m4, m7
    palignr     m5, m0, 11
    pshufb      m5, m7
    palignr     m6, m0, 12
    pshufb      m6, m7

    movu        [r5 + r4], m1
    movu        [r5 + r4 + 16], m1
    lea         r5, [r5 + r1 * 4]
    movu        [r5], m2
    movu        [r5 + 16], m2
    movu        [r5 + r1], m3
    movu        [r5 + r1 + 16], m3
    movu        [r5 + r1 * 2], m4
    movu        [r5 + r1 * 2 + 16], m4
    movu        [r5 + r4], m5
    movu        [r5 + r4 + 16], m5
    lea         r5, [r5 + r1 * 4]
    movu        [r5], m6
    movu        [r5 + 16], m6

    palignr     m1, m0, 13
    pshufb      m1, m7
    palignr     m2, m0, 14
    pshufb      m2, m7
    palignr     m3, m0, 15
    pshufb      m3, m7
    pshufb      m0, m7

    movu        [r5 + r1], m1
    movu        [r5 + r1 + 16], m1
    movu        [r5 + r1 * 2], m2
    movu        [r5 + r1 * 2 + 16], m2
    movu        [r5 + r4], m3
    movu        [r5 + r4 + 16], m3

; filter
    cmp         r3d, byte 0
    jz         .quit
    movhlps     m1, m0
    pmovzxbw    m0, m0
    mova        m1, m0
    movu        m2, m8
    movu        m3, m9

    pshufb      m2, m7
    pmovzxbw    m2, m2
    movhlps     m4, m3
    pmovzxbw    m3, m3
    pmovzxbw    m4, m4
    psubw       m3, m2
    psubw       m4, m2
    psraw       m3, 1
    psraw       m4, 1
    paddw       m0, m3
    paddw       m1, m4
    packuswb    m0, m1

.quit:
    movu        [r0], m0
    movu        [r0 + 16], m0
    dec         r6
    lea         r0, [r5 + r1 * 4]
    lea         r2, [r2 + 16]
    jnz         .loop
    RET

INIT_XMM sse4
cglobal intra_pred_ang32_11, 4,7,8
    ; NOTE: alignment stack to 64 bytes, so all of local data in same cache line
    mov         r6, rsp
    sub         rsp, 64+gprsize
    and         rsp, ~63
    mov         [rsp+64], r6

    ; collect reference pixel
    movu        m0, [r2 + 16]
    pxor        m1, m1
    pshufb      m0, m1                   ; [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
    mova        [rsp], m0
    movu        m0, [r2 + 64]
    pinsrb      m0, [r2], 0
    movu        m1, [r2 + 16 + 64]
    movu        m2, [r2 + 32 + 64]
    movu        [rsp + 1], m0
    movu        [rsp + 1 + 16], m1
    movu        [rsp + 1 + 32], m2
    mov         [rsp + 63], byte 4

    ; filter
    lea         r2, [rsp + 1]            ; r2 -> [0]
    lea         r3, [c_shuf8_0]          ; r3 -> shuffle8
    lea         r4, [ang_table]          ; r4 -> ang_table
    lea         r5, [r1 * 3]             ; r5 -> 3 * stride
    lea         r6, [r0 + r1 * 4]        ; r6 -> 4 * stride
    mova        m5, [pw_1024]            ; m5 -> 1024
    mova        m6, [c_deinterval8]      ; m6 -> c_deinterval8

.loop:
    ; Row[0 - 7]
    movu        m7, [r2]
    mova        m0, m7
    mova        m1, m7
    mova        m2, m7
    mova        m3, m7
    mova        m4, m7
    mova        m5, m7
    mova        m6, m7
    PROC32_8x8  0, 1, 30,28,26,24,22,20,18,16

    ; Row[8 - 15]
    movu        m7, [r2]
    mova        m0, m7
    mova        m1, m7
    mova        m2, m7
    mova        m3, m7
    mova        m4, m7
    mova        m5, m7
    mova        m6, m7
    PROC32_8x8  1, 1, 14,12,10,8,6,4,2,0

    ; Row[16 - 23]
    movu        m7, [r2 - 1]
    mova        m0, m7
    mova        m1, m7
    mova        m2, m7
    mova        m3, m7
    mova        m4, m7
    mova        m5, m7
    mova        m6, m7
    PROC32_8x8  2, 1, 30,28,26,24,22,20,18,16

    ; Row[24 - 31]
    movu        m7, [r2 - 1]
    mova        m0, m7
    mova        m1, m7
    mova        m2, m7
    mova        m3, m7
    mova        m4, m7
    mova        m5, m7
    mova        m6, m7
    PROC32_8x8  3, 1, 14,12,10,8,6,4,2,0

    lea         r0, [r6 + r1 * 4]
    lea         r6, [r6 + r1 * 8]
    add         r2, 8
    dec         byte [rsp + 63]
    jnz        .loop
    mov         rsp, [rsp+64]
    RET

%macro MODE_12_24_ROW0 1
    movu        m0,        [r3 + 6]
    pshufb      m0,        [c_mode32_12_0]
    pinsrb      m0,        [r3 + 26], 12
    mova        above,     m0
    movu        m2,        [r2]
  %if %1 == 1
    pinsrb      m2,        [r3], 0
  %endif
    palignr     m1,        m2, 1
    punpcklbw   m2,        m1
    pmaddubsw   m4,        m2, [r4 + 11 * 16]         ; [27]
    pmulhrsw    m4,        m7
    pmaddubsw   m3,        m2, [r4 + 6 * 16]          ; [22]
    pmulhrsw    m3,        m7
    packuswb    m4,        m3
    pmaddubsw   m5,        m2, [r4 + 16]              ; [17]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m2, [r4 - 4 * 16]          ; [12]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6
    pmaddubsw   m6,        m2, [r4 - 9 * 16]          ; [7]
    pmulhrsw    m6,        m7
    pmaddubsw   m3,        m2, [r4 - 14 * 16]         ; [2]
    pmulhrsw    m3,        m7
    packuswb    m6,        m3
    movu        m1,        [r2]                       ; [15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0]
  %if %1 == 1
    pinsrb      m1,        [r3], 0
  %endif
    palignr     m2,        m1, above, 15              ; [14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 a]
    punpcklbw   m2,        m1                         ; [7 6 6 5 5 4 4 3 3 2 2 1 1 0 0 a]
    pmaddubsw   m1,        m2, [r4 + 13 * 16]             ; [29]
    pmulhrsw    m1,        m7
    pmaddubsw   m3,        m2, [r4 + 8 * 16]          ; [24]
    pmulhrsw    m3,        m7
    packuswb    m1,        m3
    TRANSPOSE_STORE_8x8 0, %1, m4, m5, m6, m1
    pmaddubsw   m4,        m2, [r4 + 3 * 16]          ; [19]
    pmulhrsw    m4,        m7
    pmaddubsw   m5,        m2, [r4 - 2 * 16]          ; [14]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5
    pmaddubsw   m5,        m2, [r4 - 7 * 16]          ; [09]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m2, [r4 - 12 * 16]         ; [04]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6
    palignr     m2,        above, 14                  ;[6 5 5 4 4 3 3 2 2 1 1 0 0 a a b]
    pmaddubsw   m6,        m2, [r4 + 15 * 16]         ; [31]
    pmulhrsw    m6,        m7
    pmaddubsw   m1,        m2, [r4 + 10 * 16]         ; [26]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1
    pmaddubsw   m1,        m2, [r4 + 5 * 16]          ; [21]
    pmulhrsw    m1,        m7
    pmaddubsw   m3,        m2, [r4]                   ; [16]
    pmulhrsw    m3,        m7
    packuswb    m1,        m3
    TRANSPOSE_STORE_8x8 1, %1, m4, m5, m6, m1
    pmaddubsw   m4,        m2, [r4 - 5 * 16]          ; [11]
    pmulhrsw    m4,        m7
    pmaddubsw   m3,        m2, [r4 - 10 * 16]         ; [06]
    pmulhrsw    m3,        m7
    packuswb    m4,        m3
    pmaddubsw   m5,        m2, [r4 - 15 * 16]         ; [1]
    pmulhrsw    m5,        m7
    pslldq      m1,        above, 1
    palignr     m2,        m1, 14
    pmaddubsw   m6,        m2, [r4 + 12 * 16]         ; [28]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6
    pmaddubsw   m6,        m2, [r4 + 7 * 16]          ; [23]
    pmulhrsw    m6,        m7
    pmaddubsw   m3,        m2, [r4 + 2 * 16]          ; [18]
    pmulhrsw    m3,        m7
    packuswb    m6,        m3
    pmaddubsw   m1,        m2, [r4 - 3 * 16]          ; [13]
    pmulhrsw    m1,        m7
    pmaddubsw   m3,        m2, [r4 - 8 * 16]          ; [8]
    pmulhrsw    m3,        m7
    packuswb    m1,        m3
    TRANSPOSE_STORE_8x8 2, %1, m4, m5, m6, m1
    pmaddubsw   m4,        m2, [r4 - 13 * 16]         ; [3]
    pmulhrsw    m4,        m7
    pslldq      m1,        above, 2
    palignr     m2,        m1, 14
    pmaddubsw   m5,        m2, [r4 + 14 * 16]         ; [30]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5
    pmaddubsw   m5,        m2, [r4 + 9 * 16]          ; [25]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m2, [r4 + 4 * 16]          ; [20]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6
    pmaddubsw   m6,        m2, [r4 - 16]              ; [15]
    pmulhrsw    m6,        m7
    pmaddubsw   m1,        m2, [r4 - 6 * 16]          ; [10]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1
    pmaddubsw   m1,        m2, [r4 - 11 * 16]         ; [05]
    pmulhrsw    m1,        m7
    movu        m0,        [pb_fact0]
    pshufb      m2,        m0
    pmovzxbw    m2,        m2
    packuswb    m1,        m2
    TRANSPOSE_STORE_8x8 3, %1, m4, m5, m6, m1
%endmacro

INIT_XMM sse4
cglobal intra_pred_ang32_12, 3,7,8,0-(1*mmsize)
  %define above    [rsp + 0 * mmsize]
    mov         r3,        r2
    add         r2,        64
    lea         r4,        [ang_table + 16 * 16]
    lea         r5,        [r1 * 3]                   ; r5 -> 3 * stride
    lea         r6,        [r0 + r1 * 4]              ; r6 -> 4 * stride
    mova        m7,        [pw_1024]

    MODE_12_24_ROW0 1
    lea         r0,        [r6 + r1 * 4]
    lea         r6,        [r6 + r1 * 8]
    add         r2,        7
    mov         r3,        3
.loop:
    MODE_12_24 1
    lea         r0,        [r6 + r1 * 4]
    lea         r6,        [r6 + r1 * 8]
    add         r2,        8
    dec         r3
    jnz         .loop
    RET

%macro MODE_13_23_ROW0 1
    movu        m0,        [r3 + 1]
    movu        m1,        [r3 + 15]
    pshufb      m0,        [c_mode32_13_0]
    pshufb      m1,        [c_mode32_13_0]
    punpckldq   m0,        m1
    pshufb      m0,        [c_mode32_13_shuf]
    mova        above,     m0
    movu        m2,        [r2]
  %if (%1 == 1)
    pinsrb      m2,        [r3], 0
  %endif
    palignr     m1,        m2, 1
    punpcklbw   m2,        m1
    pmaddubsw   m4,        m2, [r4 + 7 * 16]         ; [23]
    pmulhrsw    m4,        m7
    pmaddubsw   m3,        m2, [r4 - 2 * 16]         ; [14]
    pmulhrsw    m3,        m7
    packuswb    m4,        m3
    pmaddubsw   m5,        m2, [r4 - 11 * 16]        ; [5]
    pmulhrsw    m5,        m7
    movu        m1,        [r2]                      ; [15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0]
  %if (%1 == 1)
    pinsrb      m1,        [r3], 0
  %endif
    palignr     m2,        m1, above, 15             ; [14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 a]
    punpcklbw   m2,        m1                        ; [7 6 6 5 5 4 4 3 3 2 2 1 1 0 0]
    pmaddubsw   m6,        m2, [r4 + 12 * 16]        ; [28]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6
    pmaddubsw   m6,        m2, [r4 + 3 * 16]         ; [19]
    pmulhrsw    m6,        m7
    pmaddubsw   m0,        m2, [r4 - 6 * 16]         ; [10]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0
    pmaddubsw   m1,        m2, [r4 - 15 * 16]        ; [1]
    pmulhrsw    m1,        m7
    palignr     m2,        above, 14
    pmaddubsw   m3,        m2, [r4 + 8 * 16]         ; [24]
    pmulhrsw    m3,        m7
    packuswb    m1,        m3
    TRANSPOSE_STORE_8x8 0, %1, m4, m5, m6, m1
    pmaddubsw   m4,        m2, [r4 - 16]             ; [15]
    pmulhrsw    m4,        m7
    pmaddubsw   m5,        m2, [r4 - 10 * 16]        ; [6]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5
    pslldq      m0,        above, 1
    palignr     m2,        m0, 14
    pmaddubsw   m5,        m2, [r4 + 13 * 16]        ; [29]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m2, [r4 + 4 * 16]         ; [20]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6
    pmaddubsw   m6,        m2, [r4 - 5 * 16]         ; [11]
    pmulhrsw    m6,        m7
    pmaddubsw   m1,        m2, [r4 - 14 * 16]        ; [2]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1
    pslldq      m0,        1
    palignr     m2,        m0, 14
    pmaddubsw   m1,        m2, [r4 + 9 * 16]         ; [25]
    pmulhrsw    m1,        m7
    pmaddubsw   m0,        m2, [r4]                  ; [16]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0
    TRANSPOSE_STORE_8x8 1, %1, m4, m5, m6, m1
    pmaddubsw   m4,        m2, [r4 - 9 * 16]         ; [7]
    pmulhrsw    m4,        m7
    pslldq      m0,        above, 3
    palignr     m2,        m0, 14
    pmaddubsw   m3,        m2, [r4 + 14 * 16]        ; [30]
    pmulhrsw    m3,        m7
    packuswb    m4,        m3
    pmaddubsw   m5,        m2, [r4 + 5 * 16]         ; [21]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m2, [r4 - 4 * 16]         ; [12]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6
    pmaddubsw   m6,        m2, [r4 - 13 * 16]        ; [3]
    pmulhrsw    m6,        m7
    pslldq      m0,        1
    palignr     m2,        m0, 14
    pmaddubsw   m0,        m2, [r4 + 10 * 16]        ; [26]
    pmulhrsw    m0,        m7
    packuswb    m6,        m0
    pmaddubsw   m1,        m2, [r4 + 16]             ; [17]
    pmulhrsw    m1,        m7
    pmaddubsw   m0,        m2, [r4 - 8 * 16]         ; [8]
    pmulhrsw    m0,        m7
    packuswb    m1,        m0
    TRANSPOSE_STORE_8x8 2, %1, m4, m5, m6, m1
    pslldq      m0,        above, 5
    palignr     m2,        m0, 14
    pmaddubsw   m4,        m2, [r4 + 15 * 16]        ; [31]
    pmulhrsw    m4,        m7
    pmaddubsw   m5,        m2, [r4 + 6 * 16]         ; [22]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5
    pmaddubsw   m5,        m2, [r4 - 3 * 16]         ; [13]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m2, [r4 - 12 * 16]        ; [04]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6
    pslldq      m0,        1
    palignr     m2,        m0, 14
    pmaddubsw   m6,        m2, [r4 + 11 * 16]        ; [27]
    pmulhrsw    m6,        m7
    pmaddubsw   m1,        m2, [r4 + 2 * 16]         ; [18]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1
    pmaddubsw   m1,        m2, [r4 - 7 * 16]         ; [09]
    pmulhrsw    m1,        m7
    pmaddubsw   m3,        m2, [r4 - 16 * 16]        ; [00]
    pmulhrsw    m3,        m7
    packuswb    m1,        m3
    TRANSPOSE_STORE_8x8 3, %1, m4, m5, m6, m1
%endmacro

%macro MODE_13_23 2
    movu        m2,        [r2]                      ; [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
    palignr     m1,        m2, 1                     ; [x ,15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1]
    punpckhbw   m0,        m2, m1                    ; [x, 15, 15, 14, 14, 13, 13, 12, 12, 11, 11, 10, 10, 9, 9, 8]
    punpcklbw   m2,        m1                        ; [8, 7, 7, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1, 1, 0]
    palignr     m0,        m2, 2                     ; [9, 8, 8, 7, 7, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1]
    pmaddubsw   m4,        m0, [r4 + 7 * 16]         ; [23]
    pmulhrsw    m4,        m7
    pmaddubsw   m3,        m0, [r4 - 2 * 16]         ; [14]
    pmulhrsw    m3,        m7
    packuswb    m4,        m3
    pmaddubsw   m5,        m0, [r4 - 11 * 16]        ; [05]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m2, [r4 + 12 * 16]        ; [28]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6
    pmaddubsw   m6,        m2, [r4 + 3 * 16]         ; [19]
    pmulhrsw    m6,        m7
    pmaddubsw   m3,        m2, [r4 - 6 * 16]         ; [10]
    pmulhrsw    m3,        m7
    packuswb    m6,        m3
    pmaddubsw   m1,        m2, [r4 - 15 * 16]        ; [1]
    pmulhrsw    m1,        m7
    movu        m2,        [r2 - 2]                  ; [14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, -1]
    palignr     m3,        m2, 1                     ; [x, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
    punpckhbw   m0,        m2, m3
    punpcklbw   m2,        m3
    palignr     m0,        m2, 2
    pmaddubsw   m3,        m0, [r4 + 8 * 16]         ; [24]
    pmulhrsw    m3,        m7
    packuswb    m1,        m3
    mova        m3,        m0
    TRANSPOSE_STORE_8x8 0, %1, m4, m5, m6, m1
    pmaddubsw   m4,        m3, [r4 - 16]             ; [15]
    pmulhrsw    m4,        m7
    pmaddubsw   m5,        m3, [r4 - 10 * 16]        ; [6]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5
    pmaddubsw   m5,        m2, [r4 + 13 * 16]        ; [29]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m2, [r4 + 4 * 16]         ; [20]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6
    pmaddubsw   m6,        m2, [r4 - 5 * 16]         ; [11]
    pmulhrsw    m6,        m7
    pmaddubsw   m1,        m2, [r4 - 14 * 16]        ; [2]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1
    movu        m2,        [r2 - 4]                  ; [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
    palignr     m1,        m2, 1                     ; [x ,15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1]
    punpckhbw   m0,        m2, m1                    ; [x, 15, 15, 14, 14, 13, 13, 12, 12, 11, 11, 10, 10, 9, 9, 8]
    punpcklbw   m2,        m1                        ; [8, 7, 7, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1, 1, 0]
    palignr     m0,        m2, 2                     ; [9, 8, 8, 7, 7, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1]
    pmaddubsw   m1,        m0, [r4 + 9 * 16]         ; [25]
    pmulhrsw    m1,        m7
    pmaddubsw   m3,        m0, [r4]                  ; [16]
    pmulhrsw    m3,        m7
    packuswb    m1,        m3
    mova        m3,        m0
    TRANSPOSE_STORE_8x8 1, %1, m4, m5, m6, m1
    pmaddubsw   m4,        m3, [r4 - 9 * 16]         ; [7]
    pmulhrsw    m4,        m7
    pmaddubsw   m3,        m2, [r4 + 14 * 16]        ; [30]
    pmulhrsw    m3,        m7
    packuswb    m4,        m3
    pmaddubsw   m5,        m2, [r4 + 5 * 16]         ; [21]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m2, [r4 - 4 * 16]         ; [12]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6
    pmaddubsw   m6,        m2, [r4 - 13 * 16]        ; [3]
    pmulhrsw    m6,        m7
    movu        m2,        [r2 - 6]                  ; [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
    palignr     m1,        m2, 1                     ; [x ,15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1]
    punpckhbw   m0,        m2, m1                    ; [x, 15, 15, 14, 14, 13, 13, 12, 12, 11, 11, 10, 10, 9, 9, 8]
    punpcklbw   m2,        m1                        ; [8, 7, 7, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1, 1, 0]
    palignr     m0,        m2, 2                     ; [9, 8, 8, 7, 7, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1]
    pmaddubsw   m3,        m0, [r4 + 10 * 16]        ; [26]
    pmulhrsw    m3,        m7
    packuswb    m6,        m3
    pmaddubsw   m1,        m0, [r4 + 16]             ; [17]
    pmulhrsw    m1,        m7
    pmaddubsw   m3,        m0, [r4 - 8 * 16]         ; [8]
    pmulhrsw    m3,        m7
    packuswb    m1,        m3
    TRANSPOSE_STORE_8x8 2, %1, m4, m5, m6, m1
    pmaddubsw   m4,        m2, [r4 + 15 * 16]        ; [31]
    pmulhrsw    m4,        m7
    pmaddubsw   m5,        m2, [r4 + 6 * 16]         ; [22]
    pmulhrsw    m5,        m7
    packuswb    m4,        m5
    pmaddubsw   m5,        m2, [r4 - 3 * 16]         ; [13]
    pmulhrsw    m5,        m7
    pmaddubsw   m6,        m2, [r4 - 12 * 16]        ; [04]
    pmulhrsw    m6,        m7
    packuswb    m5,        m6
    movu        m2,        [r2 - 7]                  ; [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
  %if ((%1 & %2) == 1)
    pinsrb      m2,        [r3], 0
  %endif
    palignr     m1,        m2, 1                     ; [x ,15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1]
    punpcklbw   m2,        m1                        ; [8, 7, 7, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1, 1, 0]
    pmaddubsw   m6,        m2, [r4 + 11 * 16]        ; [27]
    pmulhrsw    m6,        m7
    pmaddubsw   m1,        m2, [r4 + 2 * 16]         ; [18]
    pmulhrsw    m1,        m7
    packuswb    m6,        m1
    pmaddubsw   m1,        m2, [r4 - 7 * 16]         ; [09]
    pmulhrsw    m1,        m7
    movu        m0,        [pb_fact0]
    pshufb      m2,        m0
    pmovzxbw    m2,        m2
    packuswb    m1,        m2
    TRANSPOSE_STORE_8x8 3, %1, m4, m5, m6, m1
%endmacro

INIT_XMM sse4
cglobal intra_pred_ang32_13, 3,7,8,0-(1*mmsize)
%define above [rsp + 0 * mmsize]
    mov         r3,        r2
    add         r2,        64
    lea         r4,        [ang_table + 16 * 16]
    lea         r5,        [r1 * 3]                  ; r5 -> 3 * stride
    lea         r6,        [r0 + r1 * 4]             ; r6 -> 4 * stride
    mova        m7,        [pw_1024]

    MODE_13_23_ROW0 1
    lea         r0,        [r6 + r1 * 4]
    lea         r6,        [r6 + r1 * 8]
    add         r2,        7

    MODE_13_23 1, 1
    lea         r0,        [r6 + r1 * 4]
    lea         r6,        [r6 + r1 * 8]
    add         r2,        8
    mov         r3,        2
.loop:
    MODE_13_23 1, 0
    lea         r0,        [r6 + r1 * 4]
    lea         r6,        [r6 + r1 * 8]
    add         r2,        8
    dec         r3
    jnz         .loop
    RET

INIT_XMM sse4
cglobal intra_pred_ang32_14, 3,7,8
    ; NOTE: alignment stack to 64 bytes, so all of local data in same cache line
    mov         r6, rsp
    sub         rsp, 64+gprsize
    and         rsp, ~63
    mov         [rsp+64], r6

    ; collect reference pixel
    movu        m0, [r2]
    movu        m1, [r2 + 15]
    pshufb      m0, [c_mode32_14_0]      ; [x x x x x x x x x 0 2 5 7 10 12 15]
    pshufb      m1, [c_mode32_14_0]      ; [x x x x x x x x x 15 17 20 22 25 27 30]
    pslldq      m1, 10                   ; [17 20 22 25 27 30 x x x x x x x x x x x]
    palignr     m0, m1, 10               ; [x x x 0 2 5 7 10 12 15 17 20 22 25 27 30]
    mova        [rsp], m0
    movu        m0, [r2 + 1 + 64]
    movu        m1, [r2 + 1 + 16 + 64]
    movu        [rsp + 13], m0
    movu        [rsp + 13 + 16], m1
    mov         [rsp + 63], byte 4

    ; filter
    lea         r2, [rsp + 13]           ; r2 -> [0]
    lea         r3, [c_shuf8_0]          ; r3 -> shuffle8
    lea         r4, [ang_table]          ; r4 -> ang_table
    lea         r5, [r1 * 3]             ; r5 -> 3 * stride
    lea         r6, [r0 + r1 * 4]        ; r6 -> 4 * stride
    mova        m5, [pw_1024]            ; m5 -> 1024
    mova        m6, [c_deinterval8]      ; m6 -> c_deinterval8

.loop:
    ; Row[0 - 7]
    movu        m7, [r2 - 4]
    palignr     m0, m7, 3
    mova        m1, m0
    palignr     m2, m7, 2
    mova        m3, m2
    palignr     m4, m7, 1
    mova        m5, m4
    mova        m6, m4
    PROC32_8x8  0, 1, 19,6,25,12,31,18,5,24

    ; Row[8 - 15]
    movu        m7, [r2 - 7]
    palignr     m0, m7, 3
    palignr     m1, m7, 2
    mova        m2, m1
    mova        m3, m1
    palignr     m4, m7, 1
    mova        m5, m4
    mova        m6, m7
    PROC32_8x8  1, 1, 11,30,17,4,23,10,29,16

    ; Row[16 - 23]
    movu        m7, [r2 - 10]
    palignr     m0, m7, 3
    palignr     m1, m7, 2
    mova        m2, m1
    palignr     m3, m7, 1
    mova        m4, m3
    mova        m5, m3
    mova        m6, m7
    PROC32_8x8  2, 1, 3,22,9,28,15,2,21,8

    ; Row[24 - 31]
    movu        m7, [r2 - 13]
    palignr     m0, m7, 2
    mova        m1, m0
    mova        m2, m0
    palignr     m3, m7, 1
    mova        m4, m3
    mova        m5, m7
    mova        m6, m7
    PROC32_8x8  3, 1, 27,14,1,20,7,26,13,0

    lea         r0, [r6 + r1 * 4]
    lea         r6, [r6 + r1 * 8]
    add         r2, 8
    dec         byte [rsp + 63]
    jnz        .loop
    mov         rsp, [rsp+64]
    RET

INIT_XMM sse4
cglobal intra_pred_ang32_15, 4,7,8
    ; NOTE: alignment stack to 64 bytes, so all of local data in same cache line
    mov         r6, rsp
    sub         rsp, 64+gprsize
    and         rsp, ~63
    mov         [rsp+64], r6

    ; collect reference pixel
    movu        m0, [r2]
    movu        m1, [r2 + 15]
    pshufb      m0, [c_mode32_15_0]      ; [x x x x x x x 0 2 4 6 8 9 11 13 15]
    pshufb      m1, [c_mode32_15_0]      ; [x x x x x x x 15 17 19 21 23 24 26 28 30]
    mova        [rsp], m1
    movu        [rsp + 8], m0
    movu        m0, [r2 + 1 + 64]
    movu        m1, [r2 + 1 + 16 + 64]
    movu        [rsp + 17], m0
    movu        [rsp + 17 + 16], m1
    mov         [rsp + 63], byte 4

    ; filter
    lea         r2, [rsp + 17]           ; r2 -> [0]
    lea         r3, [c_shuf8_0]          ; r3 -> shuffle8
    lea         r4, [ang_table]          ; r4 -> ang_table
    lea         r5, [r1 * 3]             ; r5 -> 3 * stride
    lea         r6, [r0 + r1 * 4]        ; r6 -> 4 * stride
    mova        m5, [pw_1024]            ; m5 -> 1024
    mova        m6, [c_deinterval8]      ; m6 -> c_deinterval8

.loop:
    ; Row[0 - 7]
    movu        m7, [r2 - 5]
    palignr     m0, m7, 4
    palignr     m1, m7, 3
    mova        m2, m1
    palignr     m3, m7, 2
    mova        m4, m3
    palignr     m5, m7, 1
    mova        m6, m5
    PROC32_8x8  0, 1, 15,30,13,28,11,26,9,24

    ; Row[8 - 15]
    movu        m7, [r2 - 9]
    palignr     m0, m7, 4
    palignr     m1, m7, 3
    mova        m2, m1
    palignr     m3, m7, 2
    mova        m4, m3
    palignr     m5, m7, 1
    mova        m6, m5
    PROC32_8x8  1, 1, 7,22,5,20,3,18,1,16

    ; Row[16 - 23]
    movu        m7, [r2 - 13]
    palignr     m0, m7, 3
    mova        m1, m0
    palignr     m2, m7, 2
    mova        m3, m2
    palignr     m4, m7, 1
    mova        m5, m4
    mova        m6, m7
    PROC32_8x8  2, 1, 31,14,29,12,27,10,25,8

    ; Row[24 - 31]
    movu        m7, [r2 - 17]
    palignr     m0, m7, 3
    mova        m1, m0
    palignr     m2, m7, 2
    mova        m3, m2
    palignr     m4, m7, 1
    mova        m5, m4
    mova        m6, m7
    PROC32_8x8  3, 1, 23,6,21,4,19,2,17,0

    lea         r0, [r6 + r1 * 4]
    lea         r6, [r6 + r1 * 8]
    add         r2, 8
    dec         byte [rsp + 63]
    jnz        .loop
    mov         rsp, [rsp+64]
    RET

INIT_XMM sse4
cglobal intra_pred_ang32_16, 4,7,8
    ; NOTE: alignment stack to 64 bytes, so all of local data in same cache line
    mov         r6, rsp
    sub         rsp, 64+gprsize
    and         rsp, ~63
    mov         [rsp+64], r6

    ; collect reference pixel
    movu        m0, [r2]
    movu        m1, [r2 + 15]
    pshufb      m0, [c_mode32_16_0]      ; [x x x x x 0 2 3 5 6 8 9 11 12 14 15]
    pshufb      m1, [c_mode32_16_0]      ; [x x x x x 15 17 18 20 21 23 24 26 27 29 30]
    mova        [rsp], m1
    movu        [rsp + 10], m0
    movu        m0, [r2 + 1 + 64]
    movu        m1, [r2 + 1 + 16 + 64]
    movu        [rsp + 21], m0
    movu        [rsp + 21 + 16], m1
    mov         [rsp + 63], byte 4

    ; filter
    lea         r2, [rsp + 21]           ; r2 -> [0]
    lea         r3, [c_shuf8_0]          ; r3 -> shuffle8
    lea         r4, [ang_table]          ; r4 -> ang_table
    lea         r5, [r1 * 3]             ; r5 -> 3 * stride
    lea         r6, [r0 + r1 * 4]        ; r6 -> 4 * stride
    mova        m5, [pw_1024]            ; m5 -> 1024
    mova        m6, [c_deinterval8]      ; m6 -> c_deinterval8

.loop:
    ; Row[0 - 7]
    movu        m7, [r2 - 6]
    palignr     m0, m7, 5
    palignr     m1, m7, 4
    mova        m2, m1
    palignr     m3, m7, 3
    palignr     m4, m7, 2
    mova        m5, m4
    palignr     m6, m7, 1
    PROC32_8x8  0, 1, 11,22,1,12,23,2,13,24

    ; Row[8 - 15]
    movu        m7, [r2 - 11]
    palignr     m0, m7, 5
    palignr     m1, m7, 4
    palignr     m2, m7, 3
    mova        m3, m2
    palignr     m4, m7, 2
    palignr     m5, m7, 1
    mova        m6, m5
    PROC32_8x8  1, 1, 3,14,25,4,15,26,5,16

    ; Row[16 - 23]
    movu        m7, [r2 - 16]
    palignr     m0, m7, 4
    mova        m1, m0
    palignr     m2, m7, 3
    palignr     m3, m7, 2
    mova        m4, m3
    palignr     m5, m7, 1
    mova        m6, m7
    PROC32_8x8  2, 1, 27,6,17,28,7,18,29,8

    ; Row[24 - 31]
    movu        m7, [r2 - 21]
    palignr     m0, m7, 4
    palignr     m1, m7, 3
    mova        m2, m1
    palignr     m3, m7, 2
    palignr     m4, m7, 1
    mova        m5, m4
    mova        m6, m7
    PROC32_8x8  3, 1, 19,30,9,20,31,10,21,0

    lea         r0, [r6 + r1 * 4]
    lea         r6, [r6 + r1 * 8]
    add         r2, 8
    dec         byte [rsp + 63]
    jnz        .loop
    mov         rsp, [rsp+64]
    RET

INIT_XMM sse4
cglobal intra_pred_ang32_17, 4,7,8
    ; NOTE: alignment stack to 64 bytes, so all of local data in same cache line
    mov         r6, rsp
    sub         rsp, 64+gprsize
    and         rsp, ~63
    mov         [rsp+64], r6

    ; collect reference pixel
    movu        m0, [r2]
    movu        m1, [r2 + 16]
    pshufb      m0, [c_mode32_17_0]
    pshufb      m1, [c_mode32_17_0]
    mova        [rsp     ], m1
    movu        [rsp + 13], m0
    movu        m0, [r2 + 1 + 64]
    movu        m1, [r2 + 1 + 16 + 64]
    movu        [rsp + 26], m0
    movu        [rsp + 26 + 16], m1
    mov         [rsp + 63], byte 4

    ; filter
    lea         r2, [rsp + 25]          ; r2 -> [0]
    lea         r3, [c_shuf8_0]         ; r3 -> shuffle8
    lea         r4, [ang_table]         ; r4 -> ang_table
    lea         r5, [r1 * 3]            ; r5 -> 3 * stride
    lea         r6, [r0 + r1 * 4]       ; r6 -> 4 * stride
    mova        m5, [pw_1024]           ; m5 -> 1024
    mova        m6, [c_deinterval8]     ; m6 -> c_deinterval8

.loop:
    ; Row[0 - 7]
    movu        m7, [r2 - 6]
    palignr     m0, m7, 6
    palignr     m1, m7, 5
    palignr     m2, m7, 4
    palignr     m3, m7, 3
    palignr     m4, m7, 2
    mova        m5, m4
    palignr     m6, m7, 1
    PROC32_8x8  0, 1, 6,12,18,24,30,4,10,16

    ; Row[7 - 15]
    movu        m7, [r2 - 12]
    palignr     m0, m7, 5
    palignr     m1, m7, 4
    mova        m2, m1
    palignr     m3, m7, 3
    palignr     m4, m7, 2
    palignr     m5, m7, 1
    mova        m6, m7
    PROC32_8x8  1, 1, 22,28,2,8,14,20,26,0

    ; Row[16 - 23]
    movu        m7, [r2 - 19]
    palignr     m0, m7, 6
    palignr     m1, m7, 5
    palignr     m2, m7, 4
    palignr     m3, m7, 3
    palignr     m4, m7, 2
    mova        m5, m4
    palignr     m6, m7, 1
    PROC32_8x8  2, 1, 6,12,18,24,30,4,10,16

    ; Row[24 - 31]
    movu        m7, [r2 - 25]
    palignr     m0, m7, 5
    palignr     m1, m7, 4
    mova        m2, m1
    palignr     m3, m7, 3
    palignr     m4, m7, 2
    palignr     m5, m7, 1
    mova        m6, m7
    PROC32_8x8  3, 1, 22,28,2,8,14,20,26,0

    lea         r0, [r6 + r1 * 4]
    lea         r6, [r6 + r1 * 8]
    add         r2, 8
    dec         byte [rsp + 63]
    jnz        .loop
    mov         rsp, [rsp+64]

    RET

INIT_XMM sse4
cglobal intra_pred_ang32_18, 4,5,5
    movu        m0, [r2]               ; [15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0]
    movu        m1, [r2 + 16]          ; [31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16]
    movu        m2, [r2 + 1 + 64]      ; [16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1]
    movu        m3, [r2 + 17 + 64]     ; [32 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17]

    lea         r2, [r1 * 2]
    lea         r3, [r1 * 3]
    lea         r4, [r1 * 4]

    movu        [r0], m0
    movu        [r0 + 16], m1

    pshufb      m2, [c_mode32_18_0]    ; [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16]
    pshufb      m3, [c_mode32_18_0]    ; [17 18 19 20 21 22 23 24 25 26 27 28 19 30 31 32]

    palignr     m4, m0, m2, 15
    movu        [r0 + r1], m4
    palignr     m4, m1, m0, 15
    movu        [r0 + r1 + 16], m4
    palignr     m4, m0, m2, 14
    movu        [r0 + r2], m4
    palignr     m4, m1, m0, 14
    movu        [r0 + r2 + 16], m4
    palignr     m4, m0, m2, 13
    movu        [r0 + r3], m4
    palignr     m4, m1, m0, 13
    movu        [r0 + r3 + 16], m4

    lea         r0, [r0 + r4]

    palignr     m4, m0, m2, 12
    movu        [r0], m4
    palignr     m4, m1, m0, 12
    movu        [r0 + 16], m4
    palignr     m4, m0, m2, 11
    movu        [r0 + r1], m4
    palignr     m4, m1, m0, 11
    movu        [r0 + r1 + 16], m4
    palignr     m4, m0, m2, 10
    movu        [r0 + r2], m4
    palignr     m4, m1, m0, 10
    movu        [r0 + r2 + 16], m4
    palignr     m4, m0, m2, 9
    movu        [r0 + r3], m4
    palignr     m4, m1, m0, 9
    movu        [r0 + r3 + 16], m4

    lea         r0, [r0 + r4]

    palignr     m4, m0, m2, 8
    movu        [r0], m4
    palignr     m4, m1, m0, 8
    movu        [r0 + 16], m4
    palignr     m4, m0, m2, 7
    movu        [r0 + r1], m4
    palignr     m4, m1, m0, 7
    movu        [r0 + r1 + 16], m4
    palignr     m4, m0, m2, 6
    movu        [r0 + r2], m4
    palignr     m4, m1, m0, 6
    movu        [r0 + r2 + 16], m4
    palignr     m4, m0, m2, 5
    movu        [r0 + r3], m4
    palignr     m4, m1, m0, 5
    movu        [r0 + r3 + 16], m4

    lea         r0, [r0 + r4]

    palignr     m4, m0, m2, 4
    movu        [r0], m4
    palignr     m4, m1, m0, 4
    movu        [r0 + 16], m4
    palignr     m4, m0, m2, 3
    movu        [r0 + r1], m4
    palignr     m4, m1, m0, 3
    movu        [r0 + r1 + 16], m4
    palignr     m4, m0, m2, 2
    movu        [r0 + r2], m4
    palignr     m4, m1, m0, 2
    movu        [r0 + r2 + 16], m4
    palignr     m4, m0, m2, 1
    movu        [r0 + r3], m4
    palignr     m4, m1, m0, 1
    movu        [r0 + r3 + 16], m4

    lea         r0, [r0 + r4]

    movu        [r0], m2
    movu        [r0 + 16], m0
    palignr     m4, m2, m3, 15
    movu        [r0 + r1], m4
    palignr     m4, m0, m2, 15
    movu        [r0 + r1 + 16], m4
    palignr     m4, m2, m3, 14
    movu        [r0 + r2], m4
    palignr     m4, m0, m2, 14
    movu        [r0 + r2 + 16], m4
    palignr     m4, m2, m3, 13
    movu        [r0 + r3], m4
    palignr     m4, m0, m2, 13
    movu        [r0 + r3 + 16], m4

    lea         r0, [r0 + r4]

    palignr     m4, m2, m3, 12
    movu        [r0], m4
    palignr     m4, m0, m2, 12
    movu        [r0 + 16], m4
    palignr     m4, m2, m3, 11
    movu        [r0 + r1], m4
    palignr     m4, m0, m2, 11
    movu        [r0 + r1 + 16], m4
    palignr     m4, m2, m3, 10
    movu        [r0 + r2], m4
    palignr     m4, m0, m2, 10
    movu        [r0 + r2 + 16], m4
    palignr     m4, m2, m3, 9
    movu        [r0 + r3], m4
    palignr     m4, m0, m2, 9
    movu        [r0 + r3 + 16], m4

    lea         r0, [r0 + r4]

    palignr     m4, m2, m3, 8
    movu        [r0], m4
    palignr     m4, m0, m2, 8
    movu        [r0 + 16], m4
    palignr     m4, m2, m3, 7
    movu        [r0 + r1], m4
    palignr     m4, m0, m2, 7
    movu        [r0 + r1 + 16], m4
    palignr     m4, m2, m3, 6
    movu        [r0 + r2], m4
    palignr     m4, m0, m2, 6
    movu        [r0 + r2 + 16], m4
    palignr     m4, m2, m3, 5
    movu        [r0 + r3], m4
    palignr     m4, m0, m2, 5
    movu        [r0 + r3 + 16], m4

    lea         r0, [r0 + r4]

    palignr     m4, m2, m3, 4
    movu        [r0], m4
    palignr     m4, m0, m2, 4
    movu        [r0 + 16], m4
    palignr     m4, m2, m3, 3
    movu        [r0 + r1], m4
    palignr     m4, m0, m2, 3
    movu        [r0 + r1 + 16], m4
    palignr     m4, m2, m3, 2
    movu        [r0 + r2], m4
    palignr     m4, m0, m2, 2
    movu        [r0 + r2 + 16], m4
    palignr     m4, m2, m3, 1
    movu        [r0 + r3], m4
    palignr     m4, m0, m2, 1
    movu        [r0 + r3 + 16], m4
    RET

INIT_XMM sse4
cglobal intra_pred_ang32_19, 4,7,8
    ; NOTE: alignment stack to 64 bytes, so all of local data in same cache line
    mov         r6, rsp
    sub         rsp, 64+gprsize
    and         rsp, ~63
    mov         [rsp+64], r6

    ; collect reference pixel
    movu        m0, [r2 + 64]
    pinsrb      m0, [r2], 0
    movu        m1, [r2 + 16 + 64]
    pshufb      m0, [c_mode32_17_0]
    pshufb      m1, [c_mode32_17_0]
    mova        [rsp     ], m1
    movu        [rsp + 13], m0
    movu        m0, [r2 + 1]
    movu        m1, [r2 + 1 + 16]
    movu        [rsp + 26], m0
    movu        [rsp + 26 + 16], m1
    mov         [rsp + 63], byte 4

    ; filter
    lea         r2, [rsp + 25]          ; r2 -> [0]
    lea         r3, [c_shuf8_0]         ; r3 -> shuffle8
    lea         r4, [ang_table]         ; r4 -> ang_table
    lea         r5, [r1 * 3]            ; r5 -> 3 * stride
    lea         r6, [r0]                ; r6 -> r0
    mova        m5, [pw_1024]           ; m5 -> 1024
    mova        m6, [c_deinterval8]     ; m6 -> c_deinterval8

.loop:
    ; Row[0 - 7]
    movu        m7, [r2 - 6]
    palignr     m0, m7, 6
    palignr     m1, m7, 5
    palignr     m2, m7, 4
    palignr     m3, m7, 3
    palignr     m4, m7, 2
    mova        m5, m4
    palignr     m6, m7, 1
    PROC32_8x8  0, 0, 6,12,18,24,30,4,10,16

    ; Row[7 - 15]
    movu        m7, [r2 - 12]
    palignr     m0, m7, 5
    palignr     m1, m7, 4
    mova        m2, m1
    palignr     m3, m7, 3
    palignr     m4, m7, 2
    palignr     m5, m7, 1
    mova        m6, m7
    lea         r0, [r0 + r1 * 4]
    PROC32_8x8  1, 0, 22,28,2,8,14,20,26,0

    ; Row[16 - 23]
    movu        m7, [r2 - 19]
    palignr     m0, m7, 6
    palignr     m1, m7, 5
    palignr     m2, m7, 4
    palignr     m3, m7, 3
    palignr     m4, m7, 2
    mova        m5, m4
    palignr     m6, m7, 1
    lea         r0, [r0 + r1 * 4]
    PROC32_8x8  2, 0, 6,12,18,24,30,4,10,16

    ; Row[24 - 31]
    movu        m7, [r2 - 25]
    palignr     m0, m7, 5
    palignr     m1, m7, 4
    mova        m2, m1
    palignr     m3, m7, 3
    palignr     m4, m7, 2
    palignr     m5, m7, 1
    mova        m6, m7
    lea         r0, [r0 + r1 * 4]
    PROC32_8x8  3, 0, 22,28,2,8,14,20,26,0

    add         r6, 8
    mov         r0, r6
    add         r2, 8
    dec         byte [rsp + 63]
    jnz        .loop
    mov         rsp, [rsp+64]
    RET

INIT_XMM sse4
cglobal intra_pred_ang32_20, 4,7,8
    ; NOTE: alignment stack to 64 bytes, so all of local data in same cache line
    mov         r6, rsp
    sub         rsp, 64+gprsize
    and         rsp, ~63
    mov         [rsp+64], r6

    ; collect reference pixel
    movu        m0, [r2 + 64]
    pinsrb      m0, [r2], 0
    movu        m1, [r2 + 15 + 64]
    pshufb      m0, [c_mode32_16_0]      ; [x x x x x 0 2 3 5 6 8 9 11 12 14 15]
    pshufb      m1, [c_mode32_16_0]      ; [x x x x x 15 17 18 20 21 23 24 26 27 29 30]
    mova        [rsp], m1
    movu        [rsp + 10], m0
    movu        m0, [r2 + 1]
    movu        m1, [r2 + 1 + 16]
    movu        [rsp + 21], m0
    movu        [rsp + 21 + 16], m1
    mov         [rsp + 63], byte 4

    ; filter
    lea         r2, [rsp + 21]           ; r2 -> [0]
    lea         r3, [c_shuf8_0]          ; r3 -> shuffle8
    lea         r4, [ang_table]          ; r4 -> ang_table
    lea         r5, [r1 * 3]             ; r5 -> 3 * stride
    lea         r6, [r0]                 ; r6 -> r0
    mova        m5, [pw_1024]            ; m5 -> 1024
    mova        m6, [c_deinterval8]      ; m6 -> c_deinterval8

.loop:
    ; Row[0 - 7]
    movu        m7, [r2 - 6]
    palignr     m0, m7, 5
    palignr     m1, m7, 4
    mova        m2, m1
    palignr     m3, m7, 3
    palignr     m4, m7, 2
    mova        m5, m4
    palignr     m6, m7, 1
    PROC32_8x8  0, 0, 11,22,1,12,23,2,13,24

    ; Row[8 - 15]
    movu        m7, [r2 - 11]
    palignr     m0, m7, 5
    palignr     m1, m7, 4
    palignr     m2, m7, 3
    mova        m3, m2
    palignr     m4, m7, 2
    palignr     m5, m7, 1
    mova        m6, m5
    lea         r0, [r0 + r1 * 4]
    PROC32_8x8  1, 0, 3,14,25,4,15,26,5,16

    ; Row[16 - 23]
    movu        m7, [r2 - 16]
    palignr     m0, m7, 4
    mova        m1, m0
    palignr     m2, m7, 3
    palignr     m3, m7, 2
    mova        m4, m3
    palignr     m5, m7, 1
    mova        m6, m7
    lea         r0, [r0 + r1 * 4]
    PROC32_8x8  2, 0, 27,6,17,28,7,18,29,8

    ; Row[24 - 31]
    movu        m7, [r2 - 21]
    palignr     m0, m7, 4
    palignr     m1, m7, 3
    mova        m2, m1
    palignr     m3, m7, 2
    palignr     m4, m7, 1
    mova        m5, m4
    mova        m6, m7
    lea         r0, [r0 + r1 * 4]
    PROC32_8x8  3, 0, 19,30,9,20,31,10,21,0

    add         r6, 8
    mov         r0, r6
    add         r2, 8
    dec         byte [rsp + 63]
    jnz        .loop
    mov         rsp, [rsp+64]
    RET

INIT_XMM sse4
cglobal intra_pred_ang32_21, 4,7,8
    ; NOTE: alignment stack to 64 bytes, so all of local data in same cache line
    mov         r6, rsp
    sub         rsp, 64+gprsize
    and         rsp, ~63
    mov         [rsp+64], r6

    ; collect reference pixel
    movu        m0, [r2 + 64]
    pinsrb      m0, [r2], 0
    movu        m1, [r2 + 15 + 64]
    pshufb      m0, [c_mode32_15_0]      ; [x x x x x x x 0 2 4 6 8 9 11 13 15]
    pshufb      m1, [c_mode32_15_0]      ; [x x x x x x x 15 17 19 21 23 24 26 28 30]
    mova        [rsp], m1
    movu        [rsp + 8], m0
    movu        m0, [r2 + 1]
    movu        m1, [r2 + 1 + 16]
    movu        [rsp + 17], m0
    movu        [rsp + 17 + 16], m1
    mov         [rsp + 63], byte 4

    ; filter
    lea         r2, [rsp + 17]           ; r2 -> [0]
    lea         r3, [c_shuf8_0]          ; r3 -> shuffle8
    lea         r4, [ang_table]          ; r4 -> ang_table
    lea         r5, [r1 * 3]             ; r5 -> 3 * stride
    lea         r6, [r0]                 ; r6 -> r0
    mova        m5, [pw_1024]            ; m5 -> 1024
    mova        m6, [c_deinterval8]      ; m6 -> c_deinterval8

.loop:
    ; Row[0 - 7]
    movu        m7, [r2 - 5]
    palignr     m0, m7, 4
    palignr     m1, m7, 3
    mova        m2, m1
    palignr     m3, m7, 2
    mova        m4, m3
    palignr     m5, m7, 1
    mova        m6, m5
    PROC32_8x8  0, 0, 15,30,13,28,11,26,9,24

    ; Row[8 - 15]
    movu        m7, [r2 - 9]
    palignr     m0, m7, 4
    palignr     m1, m7, 3
    mova        m2, m1
    palignr     m3, m7, 2
    mova        m4, m3
    palignr     m5, m7, 1
    mova        m6, m5
    lea         r0, [r0 + r1 * 4]
    PROC32_8x8  1, 0, 7,22,5,20,3,18,1,16

    ; Row[16 - 23]
    movu        m7, [r2 - 13]
    palignr     m0, m7, 3
    mova        m1, m0
    palignr     m2, m7, 2
    mova        m3, m2
    palignr     m4, m7, 1
    mova        m5, m4
    mova        m6, m7
    lea         r0, [r0 + r1 * 4]
    PROC32_8x8  2, 0, 31,14,29,12,27,10,25,8

    ; Row[24 - 31]
    movu        m7, [r2 - 17]
    palignr     m0, m7, 3
    mova        m1, m0
    palignr     m2, m7, 2
    mova        m3, m2
    palignr     m4, m7, 1
    mova        m5, m4
    mova        m6, m7
    lea         r0, [r0 + r1 * 4]
    PROC32_8x8  3, 0, 23,6,21,4,19,2,17,0

    add         r6, 8
    mov         r0, r6
    add         r2, 8
    dec         byte [rsp + 63]
    jnz        .loop
    mov         rsp, [rsp+64]
    RET

INIT_XMM sse4
cglobal intra_pred_ang32_22, 4,7,8
    ; NOTE: alignment stack to 64 bytes, so all of local data in same cache line
    mov         r6, rsp
    sub         rsp, 64+gprsize
    and         rsp, ~63
    mov         [rsp+64], r6

    ; collect reference pixel
    movu        m0, [r2 + 64]
    pinsrb      m0, [r2], 0
    movu        m1, [r2 + 15 + 64]
    pshufb      m0, [c_mode32_14_0]      ; [x x x x x x x x x 0 2 5 7 10 12 15]
    pshufb      m1, [c_mode32_14_0]      ; [x x x x x x x x x 15 17 20 22 25 27 30]
    pslldq      m1, 10                   ; [17 20 22 25 27 30 x x x x x x x x x x x]
    palignr     m0, m1, 10               ; [x x x 0 2 5 7 10 12 15 17 20 22 25 27 30]
    mova        [rsp], m0
    movu        m0, [r2 + 1]
    movu        m1, [r2 + 1 + 16]
    movu        [rsp + 13], m0
    movu        [rsp + 13 + 16], m1
    mov         [rsp + 63], byte 4

    ; filter
    lea         r2, [rsp + 13]           ; r2 -> [0]
    lea         r3, [c_shuf8_0]          ; r3 -> shuffle8
    lea         r4, [ang_table]          ; r4 -> ang_table
    lea         r5, [r1 * 3]             ; r5 -> 3 * stride
    lea         r6, [r0]                 ; r6 -> r0
    mova        m5, [pw_1024]            ; m5 -> 1024
    mova        m6, [c_deinterval8]      ; m6 -> c_deinterval8

.loop:
    ; Row[0 - 7]
    movu        m7, [r2 - 4]
    palignr     m0, m7, 3
    mova        m1, m0
    palignr     m2, m7, 2
    mova        m3, m2
    palignr     m4, m7, 1
    mova        m5, m4
    mova        m6, m4
    PROC32_8x8  0, 0, 19,6,25,12,31,18,5,24

    ; Row[8 - 15]
    movu        m7, [r2 - 7]
    palignr     m0, m7, 3
    palignr     m1, m7, 2
    mova        m2, m1
    mova        m3, m1
    palignr     m4, m7, 1
    mova        m5, m4
    mova        m6, m7
    lea         r0, [r0 + r1 * 4]
    PROC32_8x8  1, 0, 11,30,17,4,23,10,29,16

    ; Row[16 - 23]
    movu        m7, [r2 - 10]
    palignr     m0, m7, 3
    palignr     m1, m7, 2
    mova        m2, m1
    palignr     m3, m7, 1
    mova        m4, m3
    mova        m5, m3
    mova        m6, m7
    lea         r0, [r0 + r1 * 4]
    PROC32_8x8  2, 0, 3,22,9,28,15,2,21,8

    ; Row[24 - 31]
    movu        m7, [r2 - 13]
    palignr     m0, m7, 2
    mova        m1, m0
    mova        m2, m0
    palignr     m3, m7, 1
    mova        m4, m3
    mova        m5, m7
    mova        m6, m7
    lea         r0, [r0 + r1 * 4]
    PROC32_8x8  3, 0, 27,14,1,20,7,26,13,0

    add         r6, 8
    mov         r0, r6
    add         r2, 8
    dec         byte [rsp + 63]
    jnz        .loop
    mov         rsp, [rsp+64]
    RET

INIT_XMM sse4
cglobal intra_pred_ang32_23, 4,7,8,0-(1*mmsize)
%define above [rsp + 0 * mmsize]
    lea         r3,        [r2 + 64]
    lea         r4,        [ang_table + 16 * 16]
    lea         r5,        [r1 * 3]            ; r5 -> 3 * stride
    mov         r6,        r0
    mova        m7,        [pw_1024]

    MODE_13_23_ROW0 0
    add         r6,        8
    mov         r0,        r6
    add         r2,        7
    mov         r3,        3
.loop:
    MODE_13_23 0, 0
    add         r6,        8
    mov         r0,        r6
    add         r2,        8
    dec         r3
    jnz         .loop
    RET

INIT_XMM sse4
cglobal intra_pred_ang32_24, 4,7,8,0-(1*mmsize)
  %define above    [rsp + 0 * mmsize]
    lea         r3,        [r2 + 64]
    lea         r4,        [ang_table + 16 * 16]
    lea         r5,        [r1 * 3]            ; r5 -> 3 * stride
    mov         r6,        r0
    mova        m7,        [pw_1024]

    MODE_12_24_ROW0 0
    add         r6,        8
    mov         r0,        r6
    add         r2,        7
    mov         r3,        3
.loop:
    MODE_12_24 0
    add         r6,        8
    mov         r0,        r6
    add         r2,        8
    dec         r3
    jnz         .loop
    RET

INIT_XMM sse4
cglobal intra_pred_ang32_25, 4,7,8
    ; NOTE: alignment stack to 64 bytes, so all of local data in same cache line
    mov         r6, rsp
    sub         rsp, 64+gprsize
    and         rsp, ~63
    mov         [rsp+64], r6

    ; collect reference pixel
    movu        m0, [r2 + 16 + 64]
    pxor        m1, m1
    pshufb      m0, m1                   ; [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
    mova        [rsp], m0
    movu        m0, [r2]
    movu        m1, [r2 + 16]
    movu        m2, [r2 + 32]
    movu        [rsp + 1], m0
    movu        [rsp + 1 + 16], m1
    movu        [rsp + 1 + 32], m2
    mov         [rsp + 63], byte 4

    ; filter
    lea         r2, [rsp + 1]            ; r2 -> [0]
    lea         r3, [c_shuf8_0]          ; r3 -> shuffle8
    lea         r4, [ang_table]          ; r4 -> ang_table
    lea         r5, [r1 * 3]             ; r5 -> 3 * stride
    lea         r6, [r0]                 ; r6 -> r0
    mova        m5, [pw_1024]            ; m5 -> 1024
    mova        m6, [c_deinterval8]      ; m6 -> c_deinterval8

.loop:
    ; Row[0 - 7]
    movu        m7, [r2]
    mova        m0, m7
    mova        m1, m7
    mova        m2, m7
    mova        m3, m7
    mova        m4, m7
    mova        m5, m7
    mova        m6, m7
    PROC32_8x8  0, 0, 30,28,26,24,22,20,18,16

    ; Row[8 - 15]
    movu        m7, [r2]
    mova        m0, m7
    mova        m1, m7
    mova        m2, m7
    mova        m3, m7
    mova        m4, m7
    mova        m5, m7
    mova        m6, m7
    lea         r0, [r0 + r1 * 4]
    PROC32_8x8  1, 0, 14,12,10,8,6,4,2,0

    ; Row[16 - 23]
    movu        m7, [r2 - 1]
    mova        m0, m7
    mova        m1, m7
    mova        m2, m7
    mova        m3, m7
    mova        m4, m7
    mova        m5, m7
    mova        m6, m7
    lea         r0, [r0 + r1 * 4]
    PROC32_8x8  2, 0, 30,28,26,24,22,20,18,16

    ; Row[24 - 31]
    movu        m7, [r2 - 1]
    mova        m0, m7
    mova        m1, m7
    mova        m2, m7
    mova        m3, m7
    mova        m4, m7
    mova        m5, m7
    mova        m6, m7
    lea         r0, [r0 + r1 * 4]
    PROC32_8x8  3, 0, 14,12,10,8,6,4,2,0

    add         r6, 8
    mov         r0, r6
    add         r2, 8
    dec         byte [rsp + 63]
    jnz        .loop
    mov         rsp, [rsp+64]
    RET

INIT_XMM sse4
cglobal intra_pred_ang32_26, 5,7,7,0-(2*mmsize)
%define m8 [rsp + 0 * mmsize]
%define m9 [rsp + 1 * mmsize]
    mov         r6,             2
    movu        m0,             [r2 + 64]
    pinsrb      m0,             [r2], 0
    movu        m1,             [r2 + 1 + 64]
    mova        m8,             m0
    mova        m9,             m1
    mov         r3d,            r4d
    lea         r4,             [r1 * 3]

.loop:
    movu        m0,             [r2 + 1]

    movu        [r0],           m0
    movu        [r0 + r1],      m0
    movu        [r0 + r1 * 2],  m0
    movu        [r0 + r4],      m0
    lea         r5,             [r0 + r1 * 4]
    movu        [r5],           m0
    movu        [r5 + r1],      m0
    movu        [r5 + r1 * 2],  m0
    movu        [r5 + r4],      m0
    lea         r5,             [r5 + r1 * 4]
    movu        [r5],           m0
    movu        [r5 + r1],      m0
    movu        [r5 + r1 * 2],  m0
    movu        [r5 + r4],      m0
    lea         r5,             [r5 + r1 * 4]
    movu        [r5],           m0
    movu        [r5 + r1],      m0
    movu        [r5 + r1 * 2],  m0
    movu        [r5 + r4],      m0
    lea         r5,             [r0 + r1 * 4]
    movu        [r5],           m0
    movu        [r5 + r1],      m0
    movu        [r5 + r1 * 2],  m0
    movu        [r5 + r4],      m0
    lea         r5,             [r5 + r1 * 4]
    movu        [r5],           m0
    movu        [r5 + r1],      m0
    movu        [r5 + r1 * 2],  m0
    movu        [r5 + r4],      m0
    lea         r5,             [r5 + r1 * 4]
    movu        [r5],           m0
    movu        [r5 + r1],      m0
    movu        [r5 + r1 * 2],  m0
    movu        [r5 + r4],      m0
    lea         r5,             [r5 + r1 * 4]
    movu        [r5],           m0
    movu        [r5 + r1],      m0
    movu        [r5 + r1 * 2],  m0
    movu        [r5 + r4],      m0
    lea         r5,             [r5 + r1 * 4]
    movu        [r5],           m0
    movu        [r5 + r1],      m0
    movu        [r5 + r1 * 2],  m0
    movu        [r5 + r4],      m0
    lea         r5,             [r5 + r1 * 4]
    movu        [r5],           m0
    movu        [r5 + r1],      m0
    movu        [r5 + r1 * 2],  m0
    movu        [r5 + r4],      m0
    lea         r5,             [r5 + r1 * 4]
    movu        [r5],           m0
    movu        [r5 + r1],      m0
    movu        [r5 + r1 * 2],  m0
    movu        [r5 + r4],      m0

; filter
    cmp         r3d, byte 0
    jz         .quit

    pxor        m4,        m4
    pshufb      m0,        m4
    pmovzxbw    m0,        m0
    mova        m1,        m0
    movu        m2,        m8
    movu        m3,        m9

    pshufb      m2,        m4
    pmovzxbw    m2,        m2
    movhlps     m4,        m3
    pmovzxbw    m3,        m3
    pmovzxbw    m4,        m4
    psubw       m3,        m2
    psubw       m4,        m2
    psraw       m3,        1
    psraw       m4,        1
    paddw       m0,        m3
    paddw       m1,        m4
    packuswb    m0,        m1

    pextrb      [r0],           m0, 0
    pextrb      [r0 + r1],      m0, 1
    pextrb      [r0 + r1 * 2],  m0, 2
    pextrb      [r0 + r4],      m0, 3
    lea         r5,             [r0 + r1 * 4]
    pextrb      [r5],           m0, 4
    pextrb      [r5 + r1],      m0, 5
    pextrb      [r5 + r1 * 2],  m0, 6
    pextrb      [r5 + r4],      m0, 7
    lea         r5,             [r5 + r1 * 4]
    pextrb      [r5],           m0, 8
    pextrb      [r5 + r1],      m0, 9
    pextrb      [r5 + r1 * 2],  m0, 10
    pextrb      [r5 + r4],      m0, 11
    lea         r5,             [r5 + r1 * 4]
    pextrb      [r5],           m0, 12
    pextrb      [r5 + r1],      m0, 13
    pextrb      [r5 + r1 * 2],  m0, 14
    pextrb      [r5 + r4],      m0, 15

.quit:
    lea         r2, [r2 + 16]
    add         r0, 16
    dec         r6d
    jnz         .loop
    RET

INIT_XMM sse4
cglobal intra_pred_ang32_27, 3,7,8
    lea         r3,        [ang_table + 16 * 16]
    mov         r4d,       4
    lea         r5,        [r1 * 3]
    mov         r6,        r0
    mova        m7,        [pw_1024]
.loop:
    MODE_9_27 0
    add         r6,        8
    mov         r0,        r6
    add         r2,        8
    dec         r4
    jnz        .loop
    RET

INIT_XMM sse4
cglobal intra_pred_ang32_28, 3,7,8
    lea         r3,        [ang_table + 16 * 16]
    mov         r4d,       4
    lea         r5,        [r1 * 3]
    mov         r6,        r0
    mova        m7,        [pw_1024]
.loop:
    MODE_8_28 0
    add         r6,        8
    mov         r0,        r6
    add         r2,        8
    dec         r4
    jnz        .loop
    RET

INIT_XMM sse4
cglobal intra_pred_ang32_29, 3,7,8
    lea         r3,        [ang_table + 16 * 16]
    mov         r4d,       4
    lea         r5,        [r1 * 3]
    mov         r6,        r0
    mova        m7,        [pw_1024]
.loop:
    MODE_7_29 0
    add         r6,        8
    mov         r0,        r6
    add         r2,        8
    dec         r4
    jnz        .loop
    RET

INIT_XMM sse4
cglobal intra_pred_ang32_30, 3,7,8
    lea         r3,        [ang_table + 16 * 16]
    mov         r4d,       4
    lea         r5,        [r1 * 3]
    mov         r6,        r0
    mova        m7,        [pw_1024]
.loop:
    MODE_6_30 0
    add         r6,        8
    mov         r0,        r6
    add         r2,        8
    dec         r4
    jnz        .loop
    RET

INIT_XMM sse4
cglobal intra_pred_ang32_31, 3,7,8
    lea         r3,        [ang_table + 16 * 16]
    mov         r4d,       4
    lea         r5,        [r1 * 3]
    mov         r6,        r0
    mova        m7,        [pw_1024]
.loop:
    MODE_5_31 0
    add         r6,        8
    mov         r0,        r6
    add         r2,        8
    dec         r4
    jnz        .loop
    RET

INIT_XMM sse4
cglobal intra_pred_ang32_32, 3,7,8
    lea         r3,     [ang_table + 16 * 16]
    mov         r4d,    4
    lea         r5,     [r1 * 3]
    mov         r6,     r0
    mova        m7,     [pw_1024]
.loop:
    MODE_4_32 0
    add         r6,      8
    mov         r0,     r6
    add         r2,     8
    dec         r4
    jnz        .loop
    RET

INIT_XMM sse4
cglobal intra_pred_ang32_33, 3,7,8
    lea         r3,    [ang_table + 16 * 16]
    mov         r4d,   4
    lea         r5,    [r1 * 3]
    mov         r6,    r0
    mova        m7,    [pw_1024]
.loop:
    MODE_3_33 0
    add         r6,    8
    mov         r0,    r6
    add         r2,    8
    dec         r4
    jnz        .loop
    RET


;-----------------------------------------------------------------------------------------
; void intraPredAng8(pixel* dst, intptr_t dstStride, pixel* src, int dirMode, int bFilter)
;-----------------------------------------------------------------------------------------
INIT_YMM avx2
cglobal intra_pred_ang8_3, 3,4,5
    mova              m3, [pw_1024]
    vbroadcasti128    m0, [r2 + 17]

    pshufb            m1, m0, [c_ang8_src1_9_2_10]
    pshufb            m2, m0, [c_ang8_src3_11_4_12]
    pshufb            m4, m0, [c_ang8_src5_13_5_13]
    pshufb            m0,     [c_ang8_src6_14_7_15]

    pmaddubsw         m1, [c_ang8_26_20]
    pmulhrsw          m1, m3
    pmaddubsw         m2, [c_ang8_14_8]
    pmulhrsw          m2, m3
    pmaddubsw         m4, [c_ang8_2_28]
    pmulhrsw          m4, m3
    pmaddubsw         m0, [c_ang8_22_16]
    pmulhrsw          m0, m3
    packuswb          m1, m2
    packuswb          m4, m0

    vperm2i128        m2, m1, m4, 00100000b
    vperm2i128        m1, m1, m4, 00110001b
    punpcklbw         m4, m2, m1
    punpckhbw         m2, m1
    punpcklwd         m1, m4, m2
    punpckhwd         m4, m2
    mova              m0, [trans8_shuf]
    vpermd            m1, m0, m1
    vpermd            m4, m0, m4

    lea               r3, [3 * r1]
    movq              [r0], xm1
    movhps            [r0 + r1], xm1
    vextracti128      xm2, m1, 1
    movq              [r0 + 2 * r1], xm2
    movhps            [r0 + r3], xm2
    lea               r0, [r0 + 4 * r1]
    movq              [r0], xm4
    movhps            [r0 + r1], xm4
    vextracti128      xm2, m4, 1
    movq              [r0 + 2 * r1], xm2
    movhps            [r0 + r3], xm2
    RET

INIT_YMM avx2
cglobal intra_pred_ang8_33, 3,4,5
    mova              m3, [pw_1024]
    vbroadcasti128    m0, [r2 + 1]

    pshufb            m1, m0, [c_ang8_src1_9_2_10]
    pshufb            m2, m0, [c_ang8_src3_11_4_12]
    pshufb            m4, m0, [c_ang8_src5_13_5_13]
    pshufb            m0,     [c_ang8_src6_14_7_15]

    pmaddubsw         m1, [c_ang8_26_20]
    pmulhrsw          m1, m3
    pmaddubsw         m2, [c_ang8_14_8]
    pmulhrsw          m2, m3
    pmaddubsw         m4, [c_ang8_2_28]
    pmulhrsw          m4, m3
    pmaddubsw         m0, [c_ang8_22_16]
    pmulhrsw          m0, m3
    packuswb          m1, m2
    packuswb          m4, m0

    lea               r3, [3 * r1]
    movq              [r0], xm1
    vextracti128      xm2, m1, 1
    movq              [r0 + r1], xm2
    movhps            [r0 + 2 * r1], xm1
    movhps            [r0 + r3], xm2
    lea               r0, [r0 + 4 * r1]
    movq              [r0], xm4
    vextracti128      xm2, m4, 1
    movq              [r0 + r1], xm2
    movhps            [r0 + 2 * r1], xm4
    movhps            [r0 + r3], xm2
    RET

INIT_YMM avx2
cglobal intra_pred_ang8_4, 3,4,5
    mova              m3, [pw_1024]
    vbroadcasti128    m0, [r2 + 17]

    pshufb            m1, m0, [c_ang8_src1_9_2_10]
    pshufb            m2, m0, [c_ang8_src2_10_3_11]
    pshufb            m4, m0, [c_ang8_src4_12_4_12]
    pshufb            m0,     [c_ang8_src5_13_6_14]

    pmaddubsw         m1, [c_ang8_21_10]
    pmulhrsw          m1, m3
    pmaddubsw         m2, [c_ang8_31_20]
    pmulhrsw          m2, m3
    pmaddubsw         m4, [c_ang8_9_30]
    pmulhrsw          m4, m3
    pmaddubsw         m0, [c_ang8_19_8]
    pmulhrsw          m0, m3
    packuswb          m1, m2
    packuswb          m4, m0

    vperm2i128        m2, m1, m4, 00100000b
    vperm2i128        m1, m1, m4, 00110001b
    punpcklbw         m4, m2, m1
    punpckhbw         m2, m1
    punpcklwd         m1, m4, m2
    punpckhwd         m4, m2
    mova              m0, [trans8_shuf]
    vpermd            m1, m0, m1
    vpermd            m4, m0, m4

    lea               r3, [3 * r1]
    movq              [r0], xm1
    movhps            [r0 + r1], xm1
    vextracti128      xm2, m1, 1
    movq              [r0 + 2 * r1], xm2
    movhps            [r0 + r3], xm2
    lea               r0, [r0 + 4 * r1]
    movq              [r0], xm4
    movhps            [r0 + r1], xm4
    vextracti128      xm2, m4, 1
    movq              [r0 + 2 * r1], xm2
    movhps            [r0 + r3], xm2
    RET

INIT_YMM avx2
cglobal intra_pred_ang8_32, 3,4,5
    mova              m3, [pw_1024]
    vbroadcasti128    m0, [r2 + 1]

    pshufb            m1, m0, [c_ang8_src1_9_2_10]
    pshufb            m2, m0, [c_ang8_src2_10_3_11]
    pshufb            m4, m0, [c_ang8_src4_12_4_12]
    pshufb            m0,     [c_ang8_src5_13_6_14]

    pmaddubsw         m1, [c_ang8_21_10]
    pmulhrsw          m1, m3
    pmaddubsw         m2, [c_ang8_31_20]
    pmulhrsw          m2, m3
    pmaddubsw         m4, [c_ang8_9_30]
    pmulhrsw          m4, m3
    pmaddubsw         m0, [c_ang8_19_8]
    pmulhrsw          m0, m3
    packuswb          m1, m2
    packuswb          m4, m0

    lea               r3, [3 * r1]
    movq              [r0], xm1
    vextracti128      xm2, m1, 1
    movq              [r0 + r1], xm2
    movhps            [r0 + 2 * r1], xm1
    movhps            [r0 + r3], xm2
    lea               r0, [r0 + 4 * r1]
    movq              [r0], xm4
    vextracti128      xm2, m4, 1
    movq              [r0 + r1], xm2
    movhps            [r0 + 2 * r1], xm4
    movhps            [r0 + r3], xm2
    RET


INIT_YMM avx2
cglobal intra_pred_ang8_5, 3, 4, 5
    mova              m3, [pw_1024]
    vbroadcasti128    m0, [r2 + 17]

    pshufb            m1, m0, [c_ang8_src1_9_2_10]
    pshufb            m2, m0, [c_ang8_src2_10_3_11]
    pshufb            m4, m0, [c_ang8_src3_11_4_12]
    pshufb            m0,     [c_ang8_src4_12_5_13]

    pmaddubsw         m1, [c_ang8_17_2]
    pmulhrsw          m1, m3
    pmaddubsw         m2, [c_ang8_19_4]
    pmulhrsw          m2, m3
    pmaddubsw         m4, [c_ang8_21_6]
    pmulhrsw          m4, m3
    pmaddubsw         m0, [c_ang8_23_8]
    pmulhrsw          m0, m3
    packuswb          m1, m2
    packuswb          m4, m0

    vperm2i128        m2, m1, m4, 00100000b
    vperm2i128        m1, m1, m4, 00110001b
    punpcklbw         m4, m2, m1
    punpckhbw         m2, m1
    punpcklwd         m1, m4, m2
    punpckhwd         m4, m2
    mova              m0, [trans8_shuf]
    vpermd            m1, m0, m1
    vpermd            m4, m0, m4

    lea               r3, [3 * r1]
    movq              [r0], xm1
    movhps            [r0 + r1], xm1
    vextracti128      xm2, m1, 1
    movq              [r0 + 2 * r1], xm2
    movhps            [r0 + r3], xm2
    lea               r0, [r0 + 4 * r1]
    movq              [r0], xm4
    movhps            [r0 + r1], xm4
    vextracti128      xm2, m4, 1
    movq              [r0 + 2 * r1], xm2
    movhps            [r0 + r3], xm2
    RET

INIT_YMM avx2
cglobal intra_pred_ang8_31, 3, 4, 5
    mova              m3, [pw_1024]
    vbroadcasti128    m0, [r2 + 1]

    pshufb            m1, m0, [c_ang8_src1_9_2_10]
    pshufb            m2, m0, [c_ang8_src2_10_3_11]
    pshufb            m4, m0, [c_ang8_src3_11_4_12]
    pshufb            m0,     [c_ang8_src4_12_5_13]

    pmaddubsw         m1, [c_ang8_17_2]
    pmulhrsw          m1, m3
    pmaddubsw         m2, [c_ang8_19_4]
    pmulhrsw          m2, m3
    pmaddubsw         m4, [c_ang8_21_6]
    pmulhrsw          m4, m3
    pmaddubsw         m0, [c_ang8_23_8]
    pmulhrsw          m0, m3
    packuswb          m1, m2
    packuswb          m4, m0

    lea               r3, [3 * r1]
    movq              [r0], xm1
    vextracti128      xm2, m1, 1
    movq              [r0 + r1], xm2
    movhps            [r0 + 2 * r1], xm1
    movhps            [r0 + r3], xm2
    lea               r0, [r0 + 4 * r1]
    movq              [r0], xm4
    vextracti128      xm2, m4, 1
    movq              [r0 + r1], xm2
    movhps            [r0 + 2 * r1], xm4
    movhps            [r0 + r3], xm2
    RET


INIT_YMM avx2
cglobal intra_pred_ang8_6, 3, 4, 5
    mova              m3, [pw_1024]
    vbroadcasti128    m0, [r2 + 17]

    pshufb            m1, m0, [intra_pred_shuff_0_8]
    pshufb            m2, m0, [c_ang8_src2_10_2_10]
    pshufb            m4, m0, [c_ang8_src3_11_3_11]
    pshufb            m0,     [c_ang8_src3_11_4_12]

    pmaddubsw         m1, [c_ang8_13_26]
    pmulhrsw          m1, m3
    pmaddubsw         m2, [c_ang8_7_20]
    pmulhrsw          m2, m3
    pmaddubsw         m4, [c_ang8_1_14]
    pmulhrsw          m4, m3
    pmaddubsw         m0, [c_ang8_27_8]
    pmulhrsw          m0, m3
    packuswb          m1, m2
    packuswb          m4, m0

    vperm2i128        m2, m1, m4, 00100000b
    vperm2i128        m1, m1, m4, 00110001b
    punpcklbw         m4, m2, m1
    punpckhbw         m2, m1
    punpcklwd         m1, m4, m2
    punpckhwd         m4, m2
    mova              m0, [trans8_shuf]
    vpermd            m1, m0, m1
    vpermd            m4, m0, m4

    lea               r3, [3 * r1]
    movq              [r0], xm1
    movhps            [r0 + r1], xm1
    vextracti128      xm2, m1, 1
    movq              [r0 + 2 * r1], xm2
    movhps            [r0 + r3], xm2
    lea               r0, [r0 + 4 * r1]
    movq              [r0], xm4
    movhps            [r0 + r1], xm4
    vextracti128      xm2, m4, 1
    movq              [r0 + 2 * r1], xm2
    movhps            [r0 + r3], xm2
    RET

INIT_YMM avx2
cglobal intra_pred_ang8_30, 3, 4, 5
    mova              m3, [pw_1024]
    vbroadcasti128    m0, [r2 + 1]

    pshufb            m1, m0, [intra_pred_shuff_0_8]
    pshufb            m2, m0, [c_ang8_src2_10_2_10]
    pshufb            m4, m0, [c_ang8_src3_11_3_11]
    pshufb            m0,     [c_ang8_src3_11_4_12]

    pmaddubsw         m1, [c_ang8_13_26]
    pmulhrsw          m1, m3
    pmaddubsw         m2, [c_ang8_7_20]
    pmulhrsw          m2, m3
    pmaddubsw         m4, [c_ang8_1_14]
    pmulhrsw          m4, m3
    pmaddubsw         m0, [c_ang8_27_8]
    pmulhrsw          m0, m3
    packuswb          m1, m2
    packuswb          m4, m0

    lea               r3, [3 * r1]
    movq              [r0], xm1
    vextracti128      xm2, m1, 1
    movq              [r0 + r1], xm2
    movhps            [r0 + 2 * r1], xm1
    movhps            [r0 + r3], xm2
    lea               r0, [r0 + 4 * r1]
    movq              [r0], xm4
    vextracti128      xm2, m4, 1
    movq              [r0 + r1], xm2
    movhps            [r0 + 2 * r1], xm4
    movhps            [r0 + r3], xm2
    RET


INIT_YMM avx2
cglobal intra_pred_ang8_9, 3, 5, 5
    mova              m3, [pw_1024]
    vbroadcasti128    m0, [r2 + 17]

    pshufb            m0, [intra_pred_shuff_0_8]

    lea               r4, [c_ang8_mode_27]
    pmaddubsw         m1, m0, [r4]
    pmulhrsw          m1, m3
    pmaddubsw         m2, m0, [r4 + mmsize]
    pmulhrsw          m2, m3
    pmaddubsw         m4, m0, [r4 + 2 * mmsize]
    pmulhrsw          m4, m3
    pmaddubsw         m0, [r4 + 3 * mmsize]
    pmulhrsw          m0, m3
    packuswb          m1, m2
    packuswb          m4, m0

    vperm2i128        m2, m1, m4, 00100000b
    vperm2i128        m1, m1, m4, 00110001b
    punpcklbw         m4, m2, m1
    punpckhbw         m2, m1
    punpcklwd         m1, m4, m2
    punpckhwd         m4, m2
    mova              m0, [trans8_shuf]
    vpermd            m1, m0, m1
    vpermd            m4, m0, m4

    lea               r3, [3 * r1]
    movq              [r0], xm1
    movhps            [r0 + r1], xm1
    vextracti128      xm2, m1, 1
    movq              [r0 + 2 * r1], xm2
    movhps            [r0 + r3], xm2
    lea               r0, [r0 + 4 * r1]
    movq              [r0], xm4
    movhps            [r0 + r1], xm4
    vextracti128      xm2, m4, 1
    movq              [r0 + 2 * r1], xm2
    movhps            [r0 + r3], xm2
    RET

INIT_YMM avx2
cglobal intra_pred_ang8_27, 3, 5, 5
    mova              m3, [pw_1024]
    vbroadcasti128    m0, [r2 + 1]

    pshufb            m0, [intra_pred_shuff_0_8]

    lea               r4, [c_ang8_mode_27]
    pmaddubsw         m1, m0, [r4]
    pmulhrsw          m1, m3
    pmaddubsw         m2, m0, [r4 + mmsize]
    pmulhrsw          m2, m3
    pmaddubsw         m4, m0, [r4 + 2 * mmsize]
    pmulhrsw          m4, m3
    pmaddubsw         m0, [r4 + 3 * mmsize]
    pmulhrsw          m0, m3
    packuswb          m1, m2
    packuswb          m4, m0

    lea               r3, [3 * r1]
    movq              [r0], xm1
    vextracti128      xm2, m1, 1
    movq              [r0 + r1], xm2
    movhps            [r0 + 2 * r1], xm1
    movhps            [r0 + r3], xm2
    lea               r0, [r0 + 4 * r1]
    movq              [r0], xm4
    vextracti128      xm2, m4, 1
    movq              [r0 + r1], xm2
    movhps            [r0 + 2 * r1], xm4
    movhps            [r0 + r3], xm2
    RET

INIT_YMM avx2
cglobal intra_pred_ang8_25, 3, 5, 5
    mova              m3, [pw_1024]
    vbroadcasti128    m0, [r2]

    pshufb            m0, [intra_pred_shuff_0_8]

    lea               r4, [c_ang8_mode_25]
    pmaddubsw         m1, m0, [r4]
    pmulhrsw          m1, m3
    pmaddubsw         m2, m0, [r4 + mmsize]
    pmulhrsw          m2, m3
    pmaddubsw         m4, m0, [r4 + 2 * mmsize]
    pmulhrsw          m4, m3
    pmaddubsw         m0, [r4 + 3 * mmsize]
    pmulhrsw          m0, m3
    packuswb          m1, m2
    packuswb          m4, m0

    lea               r3, [3 * r1]
    movq              [r0], xm1
    vextracti128      xm2, m1, 1
    movq              [r0 + r1], xm2
    movhps            [r0 + 2 * r1], xm1
    movhps            [r0 + r3], xm2
    lea               r0, [r0 + 4 * r1]
    movq              [r0], xm4
    vextracti128      xm2, m4, 1
    movq              [r0 + r1], xm2
    movhps            [r0 + 2 * r1], xm4
    movhps            [r0 + r3], xm2
    RET


INIT_YMM avx2
cglobal intra_pred_ang8_7, 3, 4, 5
    mova              m3, [pw_1024]
    vbroadcasti128    m0, [r2 + 17]

    pshufb            m1, m0, [intra_pred_shuff_0_8]
    pshufb            m2, m0, [c_ang8_src1_9_2_10]
    pshufb            m4, m0, [c_ang8_src2_10_2_10]
    pshufb            m0,     [c_ang8_src2_10_3_11]

    pmaddubsw         m1, [c_ang8_9_18]
    pmulhrsw          m1, m3
    pmaddubsw         m2, [c_ang8_27_4]
    pmulhrsw          m2, m3
    pmaddubsw         m4, [c_ang8_13_22]
    pmulhrsw          m4, m3
    pmaddubsw         m0, [c_ang8_31_8]
    pmulhrsw          m0, m3
    packuswb          m1, m2
    packuswb          m4, m0

    vperm2i128        m2, m1, m4, 00100000b
    vperm2i128        m1, m1, m4, 00110001b
    punpcklbw         m4, m2, m1
    punpckhbw         m2, m1
    punpcklwd         m1, m4, m2
    punpckhwd         m4, m2
    mova              m0, [trans8_shuf]
    vpermd            m1, m0, m1
    vpermd            m4, m0, m4

    lea               r3, [3 * r1]
    movq              [r0], xm1
    movhps            [r0 + r1], xm1
    vextracti128      xm2, m1, 1
    movq              [r0 + 2 * r1], xm2
    movhps            [r0 + r3], xm2
    lea               r0, [r0 + 4 * r1]
    movq              [r0], xm4
    movhps            [r0 + r1], xm4
    vextracti128      xm2, m4, 1
    movq              [r0 + 2 * r1], xm2
    movhps            [r0 + r3], xm2
    RET

INIT_YMM avx2
cglobal intra_pred_ang8_29, 3, 4, 5
    mova              m3, [pw_1024]
    vbroadcasti128    m0, [r2 + 1]

    pshufb            m1, m0, [intra_pred_shuff_0_8]
    pshufb            m2, m0, [c_ang8_src1_9_2_10]
    pshufb            m4, m0, [c_ang8_src2_10_2_10]
    pshufb            m0,     [c_ang8_src2_10_3_11]

    pmaddubsw         m1, [c_ang8_9_18]
    pmulhrsw          m1, m3
    pmaddubsw         m2, [c_ang8_27_4]
    pmulhrsw          m2, m3
    pmaddubsw         m4, [c_ang8_13_22]
    pmulhrsw          m4, m3
    pmaddubsw         m0, [c_ang8_31_8]
    pmulhrsw          m0, m3
    packuswb          m1, m2
    packuswb          m4, m0

    lea               r3, [3 * r1]
    movq              [r0], xm1
    vextracti128      xm2, m1, 1
    movq              [r0 + r1], xm2
    movhps            [r0 + 2 * r1], xm1
    movhps            [r0 + r3], xm2
    lea               r0, [r0 + 4 * r1]
    movq              [r0], xm4
    vextracti128      xm2, m4, 1
    movq              [r0 + r1], xm2
    movhps            [r0 + 2 * r1], xm4
    movhps            [r0 + r3], xm2
    RET


INIT_YMM avx2
cglobal intra_pred_ang8_8, 3, 4, 6
    mova              m3, [pw_1024]
    vbroadcasti128    m0, [r2 + 17]
    mova              m5, [intra_pred_shuff_0_8]

    pshufb            m1, m0, m5
    pshufb            m2, m0, m5
    pshufb            m4, m0, m5
    pshufb            m0,     [c_ang8_src2_10_2_10]

    pmaddubsw         m1, [c_ang8_5_10]
    pmulhrsw          m1, m3
    pmaddubsw         m2, [c_ang8_15_20]
    pmulhrsw          m2, m3
    pmaddubsw         m4, [c_ang8_25_30]
    pmulhrsw          m4, m3
    pmaddubsw         m0, [c_ang8_3_8]
    pmulhrsw          m0, m3
    packuswb          m1, m2
    packuswb          m4, m0

    vperm2i128        m2, m1, m4, 00100000b
    vperm2i128        m1, m1, m4, 00110001b
    punpcklbw         m4, m2, m1
    punpckhbw         m2, m1
    punpcklwd         m1, m4, m2
    punpckhwd         m4, m2
    mova              m0, [trans8_shuf]
    vpermd            m1, m0, m1
    vpermd            m4, m0, m4

    lea               r3, [3 * r1]
    movq              [r0], xm1
    movhps            [r0 + r1], xm1
    vextracti128      xm2, m1, 1
    movq              [r0 + 2 * r1], xm2
    movhps            [r0 + r3], xm2
    lea               r0, [r0 + 4 * r1]
    movq              [r0], xm4
    movhps            [r0 + r1], xm4
    vextracti128      xm2, m4, 1
    movq              [r0 + 2 * r1], xm2
    movhps            [r0 + r3], xm2
    RET

INIT_YMM avx2
cglobal intra_pred_ang8_28, 3, 4, 6
    mova              m3, [pw_1024]
    vbroadcasti128    m0, [r2 + 1]
    mova              m5, [intra_pred_shuff_0_8]

    pshufb            m1, m0, m5
    pshufb            m2, m0, m5
    pshufb            m4, m0, m5
    pshufb            m0,     [c_ang8_src2_10_2_10]

    pmaddubsw         m1, [c_ang8_5_10]
    pmulhrsw          m1, m3
    pmaddubsw         m2, [c_ang8_15_20]
    pmulhrsw          m2, m3
    pmaddubsw         m4, [c_ang8_25_30]
    pmulhrsw          m4, m3
    pmaddubsw         m0, [c_ang8_3_8]
    pmulhrsw          m0, m3
    packuswb          m1, m2
    packuswb          m4, m0

    lea               r3, [3 * r1]
    movq              [r0], xm1
    vextracti128      xm2, m1, 1
    movq              [r0 + r1], xm2
    movhps            [r0 + 2 * r1], xm1
    movhps            [r0 + r3], xm2
    lea               r0, [r0 + 4 * r1]
    movq              [r0], xm4
    vextracti128      xm2, m4, 1
    movq              [r0 + r1], xm2
    movhps            [r0 + 2 * r1], xm4
    movhps            [r0 + r3], xm2
    RET


INIT_YMM avx2
cglobal intra_pred_ang8_11, 3, 5, 5
    mova              m3, [pw_1024]
    movu              xm1, [r2 + 16]
    pinsrb            xm1, [r2], 0
    pshufb            xm1, [intra_pred_shuff_0_8]
    vinserti128       m0, m1, xm1, 1

    lea               r4, [c_ang8_mode_25]
    pmaddubsw         m1, m0, [r4]
    pmulhrsw          m1, m3
    pmaddubsw         m2, m0, [r4 + mmsize]
    pmulhrsw          m2, m3
    pmaddubsw         m4, m0, [r4 + 2 * mmsize]
    pmulhrsw          m4, m3
    pmaddubsw         m0, [r4 + 3 * mmsize]
    pmulhrsw          m0, m3
    packuswb          m1, m2
    packuswb          m4, m0

    vperm2i128        m2, m1, m4, 00100000b
    vperm2i128        m1, m1, m4, 00110001b
    punpcklbw         m4, m2, m1
    punpckhbw         m2, m1
    punpcklwd         m1, m4, m2
    punpckhwd         m4, m2
    mova              m0, [trans8_shuf]
    vpermd            m1, m0, m1
    vpermd            m4, m0, m4

    lea               r3, [3 * r1]
    movq              [r0], xm1
    movhps            [r0 + r1], xm1
    vextracti128      xm2, m1, 1
    movq              [r0 + 2 * r1], xm2
    movhps            [r0 + r3], xm2
    lea               r0, [r0 + 4 * r1]
    movq              [r0], xm4
    movhps            [r0 + r1], xm4
    vextracti128      xm2, m4, 1
    movq              [r0 + 2 * r1], xm2
    movhps            [r0 + r3], xm2
    RET


INIT_YMM avx2
cglobal intra_pred_ang8_12, 3, 5, 5
    mova              m3, [pw_1024]
    movu              xm1, [r2 + 16]
    pinsrb            xm1, [r2], 0
    pshufb            xm1, [intra_pred_shuff_0_8]
    vinserti128       m0, m1, xm1, 1

    lea               r4, [c_ang8_mode_24]
    pmaddubsw         m1, m0, [r4]
    pmulhrsw          m1, m3
    pmaddubsw         m2, m0, [r4 + mmsize]
    pmulhrsw          m2, m3
    pmaddubsw         m4, m0, [r4 + 2 * mmsize]
    pmulhrsw          m4, m3
    pslldq            xm0, 2
    pinsrb            xm0, [r2 + 6], 0
    pinsrb            xm0, [r2 + 0], 1
    vinserti128       m0, m0, xm0, 1
    pmaddubsw         m0, [r4 + 3 * mmsize]
    pmulhrsw          m0, m3
    packuswb          m1, m2
    packuswb          m4, m0

    vperm2i128        m2, m1, m4, 00100000b
    vperm2i128        m1, m1, m4, 00110001b
    punpcklbw         m4, m2, m1
    punpckhbw         m2, m1
    punpcklwd         m1, m4, m2
    punpckhwd         m4, m2
    mova              m0, [trans8_shuf]
    vpermd            m1, m0, m1
    vpermd            m4, m0, m4

    lea               r3, [3 * r1]
    movq              [r0], xm1
    movhps            [r0 + r1], xm1
    vextracti128      xm2, m1, 1
    movq              [r0 + 2 * r1], xm2
    movhps            [r0 + r3], xm2
    lea               r0, [r0 + 4 * r1]
    movq              [r0], xm4
    movhps            [r0 + r1], xm4
    vextracti128      xm2, m4, 1
    movq              [r0 + 2 * r1], xm2
    movhps            [r0 + r3], xm2
    RET

INIT_YMM avx2
cglobal intra_pred_ang8_24, 3, 5, 5
    mova              m3, [pw_1024]
    vbroadcasti128    m0, [r2]

    pshufb            m0, [intra_pred_shuff_0_8]

    lea               r4, [c_ang8_mode_24]
    pmaddubsw         m1, m0, [r4]
    pmulhrsw          m1, m3
    pmaddubsw         m2, m0, [r4 + mmsize]
    pmulhrsw          m2, m3
    pmaddubsw         m4, m0, [r4 + 2 * mmsize]
    pmulhrsw          m4, m3
    pslldq            xm0, 2
    pinsrb            xm0, [r2 + 16 + 6], 0
    pinsrb            xm0, [r2 + 0], 1
    vinserti128       m0, m0, xm0, 1
    pmaddubsw         m0, [r4 + 3 * mmsize]
    pmulhrsw          m0, m3
    packuswb          m1, m2
    packuswb          m4, m0

    lea               r3, [3 * r1]
    movq              [r0], xm1
    vextracti128      xm2, m1, 1
    movq              [r0 + r1], xm2
    movhps            [r0 + 2 * r1], xm1
    movhps            [r0 + r3], xm2
    lea               r0, [r0 + 4 * r1]
    movq              [r0], xm4
    vextracti128      xm2, m4, 1
    movq              [r0 + r1], xm2
    movhps            [r0 + 2 * r1], xm4
    movhps            [r0 + r3], xm2
    RET

%macro INTRA_PRED_ANG16_MC0 3
    pmaddubsw         m3, m1, [r4 + %3 * mmsize]
    pmulhrsw          m3, m0
    pmaddubsw         m4, m2, [r4 + %3 * mmsize]
    pmulhrsw          m4, m0
    packuswb          m3, m4
    movu              [%1], xm3
    vextracti128      xm4, m3, 1
    movu              [%2], xm4
%endmacro

%macro INTRA_PRED_ANG16_MC1 1
    INTRA_PRED_ANG16_MC0 r0, r0 + r1, %1
    INTRA_PRED_ANG16_MC0 r0 + 2 * r1, r0 + r3, (%1 + 1)
%endmacro

INIT_YMM avx2
cglobal intra_pred_ang16_25, 3, 5, 5
    mova              m0, [pw_1024]

    vbroadcasti128    m1, [r2]
    pshufb            m1, [intra_pred_shuff_0_8]
    vbroadcasti128    m2, [r2 + 8]
    pshufb            m2, [intra_pred_shuff_0_8]

    lea               r3, [3 * r1]
    lea               r4, [c_ang16_mode_25]

    INTRA_PRED_ANG16_MC1 0

    lea    r0, [r0 + 4 * r1]
    INTRA_PRED_ANG16_MC1 2

    add           r4, 4 * mmsize

    lea    r0, [r0 + 4 * r1]
    INTRA_PRED_ANG16_MC1 0

    lea    r0, [r0 + 4 * r1]
    INTRA_PRED_ANG16_MC1 2
    RET

INIT_YMM avx2
cglobal intra_pred_ang16_28, 3, 5, 6
    mova              m0, [pw_1024]
    mova              m5, [intra_pred_shuff_0_8]
    lea               r3, [3 * r1]
    lea               r4, [c_ang16_mode_28]

    vbroadcasti128    m1, [r2 + 1]
    pshufb            m1, m5
    vbroadcasti128    m2, [r2 + 9]
    pshufb            m2, m5

    INTRA_PRED_ANG16_MC1 0

    lea               r0, [r0 + 4 * r1]

    INTRA_PRED_ANG16_MC0 r0, r0 + r1, 2

    vbroadcasti128    m1, [r2 + 2]
    pshufb            m1, m5
    vbroadcasti128    m2, [r2 + 10]
    pshufb            m2, m5

    INTRA_PRED_ANG16_MC0 r0 + 2 * r1, r0 + r3, 3

    lea               r0, [r0 + 4 * r1]
    add               r4, 4 * mmsize

    INTRA_PRED_ANG16_MC1 0

    vbroadcasti128    m1, [r2 + 3]
    pshufb            m1, m5
    vbroadcasti128    m2, [r2 + 11]
    pshufb            m2, m5

    lea               r0, [r0 + 4 * r1]

    INTRA_PRED_ANG16_MC1 2
    RET

INIT_YMM avx2
cglobal intra_pred_ang16_27, 3, 5, 5
    mova              m0, [pw_1024]
    lea               r3, [3 * r1]
    lea               r4, [c_ang16_mode_27]

    vbroadcasti128    m1, [r2 + 1]
    pshufb            m1, [intra_pred_shuff_0_8]
    vbroadcasti128    m2, [r2 + 9]
    pshufb            m2, [intra_pred_shuff_0_8]

    INTRA_PRED_ANG16_MC1 0

    lea               r0, [r0 + 4 * r1]
    INTRA_PRED_ANG16_MC1 2

    lea               r0, [r0 + 4 * r1]
    add               r4, 4 * mmsize
    INTRA_PRED_ANG16_MC1 0

    lea               r0, [r0 + 4 * r1]
    INTRA_PRED_ANG16_MC0 r0, r0 + r1, 2

    vperm2i128        m1, m1, m2, 00100000b
    pmaddubsw         m3, m1, [r4 + 3 * mmsize]
    pmulhrsw          m3, m0
    vbroadcasti128    m2, [r2 + 2]
    pshufb            m2, [intra_pred_shuff_0_15]
    pmaddubsw         m2, [r4 + 4 * mmsize]
    pmulhrsw          m2, m0
    packuswb          m3, m2
    vpermq            m3, m3, 11011000b
    movu              [r0 + 2 * r1], xm3
    vextracti128      xm4, m3, 1
    movu              [r0 + r3], xm4
    RET

INIT_YMM avx2
cglobal intra_pred_ang16_29, 3, 5, 5
    mova              m0, [pw_1024]
    mova              m5, [intra_pred_shuff_0_8]
    lea               r3, [3 * r1]
    lea               r4, [c_ang16_mode_29]

    vbroadcasti128    m1, [r2 + 1]
    pshufb            m1, m5
    vbroadcasti128    m2, [r2 + 9]
    pshufb            m2, m5

    INTRA_PRED_ANG16_MC0 r0, r0 + r1, 0

    vperm2i128        m1, m1, m2, 00100000b
    pmaddubsw         m3, m1, [r4 + 1 * mmsize]
    pmulhrsw          m3, m0
    packuswb          m3, m3
    vpermq            m3, m3, 11011000b
    movu              [r0 + 2 * r1], xm3

    vbroadcasti128    m1, [r2 + 2]
    pshufb            m1, m5
    vbroadcasti128    m2, [r2 + 10]
    pshufb            m2, m5

    INTRA_PRED_ANG16_MC0 r0 + r3, r0 + 4 * r1, 2

    lea               r0, [r0 + r1 * 4]
    INTRA_PRED_ANG16_MC0 r0 + r1, r0 + 2 * r1, 3

    vbroadcasti128    m1, [r2 + 3]
    pshufb            m1, m5
    vbroadcasti128    m2, [r2 + 11]
    pshufb            m2, m5

    add               r4, 4 * mmsize
    INTRA_PRED_ANG16_MC0 r0 + r3, r0 + 4 * r1, 0
    lea               r0, [r0 + r1 * 4]

    vperm2i128        m1, m1, m2, 00100000b
    pmaddubsw         m3, m1, [r4 + 1 * mmsize]
    pmulhrsw          m3, m0
    packuswb          m3, m3
    vpermq            m3, m3, 11011000b
    movu              [r0 + r1], xm3

    vbroadcasti128    m1, [r2 + 4]
    pshufb            m1, m5
    vbroadcasti128    m2, [r2 + 12]
    pshufb            m2, m5

    INTRA_PRED_ANG16_MC0 r0 + 2 * r1, r0 + r3, 2
    lea               r0, [r0 + r1 * 4]
    INTRA_PRED_ANG16_MC0 r0, r0 + r1, 3

    add               r4, 4 * mmsize
    vbroadcasti128    m1, [r2 + 5]
    pshufb            m1, m5
    vbroadcasti128    m2, [r2 + 13]
    pshufb            m2, m5

    INTRA_PRED_ANG16_MC0 r0 + 2 * r1, r0 + r3, 0
    RET
