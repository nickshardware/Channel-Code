100 COLOR 2, 1
110 CLS
120 P1$ = "N": R = 2: C = 2: GOSUB 290: GOSUB 540
130 P1$ = "I": R = 2: C = 7: GOSUB 290: GOSUB 540
140 P1$ = "C": R = 2: C = 13: GOSUB 290: GOSUB 540
150 P1$ = "K": R = 2: C = 19: GOSUB 290: GOSUB 540
160 P1$ = "S": R = 2: C = 25: GOSUB 290: GOSUB 540
170 P1$ = "H": R = 9: C = 2: GOSUB 290: GOSUB 540
180 P1$ = "A": R = 9: C = 8: GOSUB 290: GOSUB 540
190 P1$ = "R": R = 9: C = 14: GOSUB 290: GOSUB 540
200 P1$ = "D": R = 9: C = 20: GOSUB 290: GOSUB 540
210 P1$ = "W": R = 9: C = 26: GOSUB 290: GOSUB 540
220 P1$ = "A": R = 9: C = 32: GOSUB 290: GOSUB 540
230 P1$ = "R": R = 9: C = 38: GOSUB 290: GOSUB 540
240 P1$ = "E": R = 9: C = 44: GOSUB 290: GOSUB 540
250 R = 17: C = 2: GOSUB 490
260 R = 19: C = 4: GOSUB 490
270 END
280 REM print character
290 IF P1$ = "N" THEN RESTORE 600
300 IF P1$ = "I" THEN RESTORE 660
310 IF P1$ = "C" THEN RESTORE 720
320 IF P1$ = "K" THEN RESTORE 780
330 IF P1$ = "S" THEN RESTORE 840
340 IF P1$ = "H" THEN RESTORE 900
350 IF P1$ = "A" THEN RESTORE 960
360 IF P1$ = "R" THEN RESTORE 1020
370 IF P1$ = "D" THEN RESTORE 1080
380 IF P1$ = "W" THEN RESTORE 1140
390 IF P1$ = "E" THEN RESTORE 1200
400 FOR I = 0 TO 4
410 READ A$
420 LOCATE R + I, C
430 FOR L = 1 TO LEN(A$)
440 CH$ = MID$(A$, L, 1)
450 IF CH$ = "X" THEN PRINT CHR$(219);  ELSE PRINT " ";
460 NEXT
470 NEXT
480 RETURN
490 REM draw lines
500 FOR I = 0 TO 49
510 LOCATE R, C + I
520 PRINT CHR$(219)
530 NEXT: RETURN
540 REM delay .1 second
550 T = TIMER + .1
560 WHILE TIMER < T
570 WEND
580 RETURN
590 REM N
600 DATA X   X
610 DATA XX  X
620 DATA X X X
630 DATA X  XX
640 DATA X   X
650 REM I
660 DATA " XXXX"
670 DATA "  XX"
680 DATA "  XX"
690 DATA "  XX"
700 DATA " XXXX"
710 REM C
720 DATA XXXXX
730 DATA XX
740 DATA XX
750 DATA XX
760 DATA XXXXX
770 REM K
780 DATA X  XX
790 DATA X XX
800 DATA XX
810 DATA X XX
820 DATA X  XX
830 REM S
840 DATA XXXXX
850 DATA X
860 DATA XXXXX
870 DATA "    X"
880 DATA XXXXX
890 REM H
900 DATA X   X
910 DATA X   X
920 DATA XXXXX
930 DATA X   X
940 DATA X   X
950 REM A
960 DATA "  X"
970 DATA " X X"
980 DATA "XXXXX"
990 DATA "X   X"
1000 DATA "X   X"
1010 REM R
1020 DATA " XXX"
1030 DATA X   X
1040 DATA XXXXX
1050 DATA X X
1060 DATA X   X
1070 REM D
1080 DATA XXXX
1090 DATA X   X
1100 DATA X   X
1110 DATA X   X
1120 DATA XXXX
1130 REM W
1140 DATA "X   X"
1150 DATA "X   X"
1160 DATA " X X"
1170 DATA " XXX"
1180 DATA " X X"
1190 DATA E
1200 DATA XXXXX               
1210 DATA X
1220 DATA XXX
1230 DATA X
1240 DATA XXXXX
