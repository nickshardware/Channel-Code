'This Demo shows you how to convert GET command Image format
    'To sprites or Objects
    'This can be done from reading from data statement or files
    'You can also convert from reading items displayed on the screen

    
    screen 1,300,190,5,1
    window 2,"RM Demo",(1,1)-(275,170),15,1

    defint a-z
    option base 1

    X=257
    c$=MKI$(X)
    PRINT ASC(LEFT$(c$,1))
    PRINT ASC(RIGHT$(c$,1))
    '   input a
    
    dim image(1000)

    'some boxes to make bobs go over
    line(0,0)-(100,100),5,bf
    line(50,50)-(200,180),7,bf

    'some little boxes drawn on screen and converted to Bob dynamicaly 
    line(150,5)-(160,10),10,bf
    line(155,7)-(165,20),11,bf
    get(150,5)-(165,20),image 
    Call GetImageSize(150,5,165,20,5,size)
    Call MakeBobImage(image(),BoxImage$,size)

    Call ReadPutImageFile("ball.xgf",image(),47)
    'Call SavePutImageFile("ball2.xgf",image(),47)
    put (10,10),image,pset
    Call MakeBobImage(image(),BobImage$,47)
    
    restore cross16
    size=151
    Call ReadPutImage(image(),size)
    put (100,40),image,pset
    Call MakeSpriteImage(image(),SpriteImage$,size)

    restore amiga:
    size=193
    Call ReadPutImage(image(),size)
    put (190,10),image,pset
    Call MakeBobImage(image(),BobImage2$,size)

    object.shape 1, BobImage$
    object.x 1,20
    object.y 1,10
    object.vy 1,10
    object.on 1
    object.start 1

    object.shape 2, BobImage2$
    object.x 2,50
    object.y 2,10
    object.vx 2,10
    object.on 2
    object.start 2


    object.shape 3, SpriteImage$
    object.x 3,250
    object.y 3,50
    object.vx 3,-10
    object.on 3
    object.start 3

    object.shape 4,BoxImage$
    object.x 4,250
    object.y 4,90
    object.vx 4,-10
    object.on 4
    object.start 4


    a$=""
    while a$=""
    sleep
    a$=inkey$
    wend 


    SUB MakeSpriteImage(ImageBuf(),ObjectImage$,size) static
    'make 4 color sprite from 4,8,16,32 color Image - use frst 2 bitplanes - width must 16 pixels 
    if (ImageBuf(1)<>16) or (ImageBuf(3)< 2) or (ImageBuf(3)>5) then exit sub
    if ImageBuf(3) <> 2 then
       size=(6+ImageBuf(2)*2*INT((ImageBuf(1)+15)/16)*2) /2
    end if
    fVSprite=1                'This will be a sprite
    SAVEBACK=8                '8 = Save background, 0 = Leave copy of image when drawing
    OVERLAY=16                '0 = solid, 16 = Transparent flag
    Flags=SAVEBACK+OVERLAY+fVSprite
    ObjectImage$=MKL$(0) 'ColorSet
    ObjectImage$=ObjectImage$+MKL$(0) 'DataSet
    ObjectImage$=ObjectImage$+MKI$(0)+MKI$(2)  'Tiefe
    ObjectImage$=ObjectImage$+MKI$(0)+MKI$(ImageBuf(1))  'Width
    ObjectImage$=ObjectImage$+MKI$(0)+MKI$(ImageBuf(2))  'Height
    ObjectImage$=ObjectImage$+MKI$(Flags)
    ObjectImage$=ObjectImage$+MKI$(3)                    '(PlanePick)  planePick def 15
    ObjectImage$=ObjectImage$+MKI$(0)  'planeOnOff
    FOR i=4 TO size       'Read only first 2 bitplanes from 4 bitplane  image
        ObjectImage$=ObjectImage$+MKI$(ImageBuf(i))
    NEXT i
    
    'Output Sprite Colors - Change Color Values
    ObjectImage$=ObjectImage$+MKI$(&HFFF)  '&HFFF is White - Color 1
    ObjectImage$=ObjectImage$+MKI$(0)      '0 is Black - Color 2
    ObjectImage$=ObjectImage$+MKI$(&H080)  '&HF80 is Orange &HF0F is pink - Color 3
    
    END SUB

    SUB MakeBobImage(ImageBuf(),ObjectImage$,size) static
    fVSprite=0 'must be 0 for bob
    SAVEBACK=8 '0 or 8 - Save Background - when 8 it saves and restore background. when set to 0 it stamps image to screeen
    OVERLAY=16 '0 or 16 -Transparent Flag - when 16 - color 0 is transparent, when flag set to 0 - color 0 is solid       
    Flags=SAVEBACK+OVERLAY+fVSprite
    ObjectImage$=MKL$(0) 'ColorSet
    ObjectImage$=ObjectImage$+MKL$(0) 'DataSet
    ObjectImage$=ObjectImage$+MKI$(0)+MKI$(ImageBuf(3))  'Bitplanes
    ObjectImage$=ObjectImage$+MKI$(0)+MKI$(ImageBuf(1))  'width
    ObjectImage$=ObjectImage$+MKI$(0)+MKI$(ImageBuf(2))  'height
    ObjectImage$=ObjectImage$+MKI$(Flags)
    ObjectImage$=ObjectImage$+MKI$(2^ImageBuf(3)-1) '(PlanePick)  planePick def 15 is for up to 4 bitplanes and 31 is for 5 bitplanes,  1 for 1 bitplane, 3 is for 2 bitplanes, 7 is for 3 bitplanes
    ObjectImage$=ObjectImage$+MKI$(0)  'planeOnOff  def 0 - hint - eable unused bitplanes that planepick uses
    FOR i=4 TO size                    'to get different color combinations
        ObjectImage$=ObjectImage$+MKI$(ImageBuf(i))
    NEXT i
    END SUB

    SUB ReadPutImage(ImageBuf(),size) static
    for i=1 to size
        read ImageBuf(i)
    next i
    END SUB

    SUB ReadPutImageFile(filename$,ImageBuf(),size) static
    open "R",#1,filename$,2
    field #1, 2 as c$
    for i=1 to size
        get #1
        ImageBuf(i)=CVI(c$)
    next i
    close #1
    END SUB

    SUB SavePutImageFile(filename$,ImageBuf(),size) static
    open "R",#1,filename$,2
    field #1, 2 as c$
    for i=1 to size
        LSET c$ = MKI$(ImageBuf(i))
        put #1
    next i
    close #1
    END SUB

    SUB GetImageSize(x,y,x2,y2,D,size) static
       size=(6+(y2-y+1)*2*INT((x2-x+16)/16)*D) /2
    END SUB

    'The required size of the array, in bytes, is:
    '6+( ( y2-yl+l)*2*INT(( x2-xl+16)/16)*D
    'where x and y are the lengths of the horizontal and vertical sides of the
    'rectangle. D is the depth of the screen, for which 2 is the default.
    'The bytes per element of an array are:
    '2 bytes for integer
    '4 bytes for single precision
    '8 bytes for double precision
    'For example, assume you want to GET (10,20)-(30,40),ARRAY%. The
    'number of bytes required is 6+(40-20+l)*2*(INT((30-10)+16)/16))*2 or
    '174 bytes. Therefore, you would need an integer array with at least 87
    'elements.







'  AmigaBASIC, Array Size= 193 Width= 20 Height= 19 Colors= 32
'  amigal
amiga:
DATA &H0014,&H0013,&H0005,&H0000,&H0000,&H0000,&H0000,&H07FE
DATA &H0000,&H0402,&H0000,&H0402,&H0000,&H0402,&H0000,&H0402
DATA &H0000,&H0402,&H0000,&H0402,&H0000,&H0402,&H0000,&H07FE
DATA &H0000,&H0000,&H0000,&H3FFF,&HC000,&H3FF8,&H4000,&H3FFF
DATA &HC000,&H3FFF,&HC000,&H1000,&H8000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H03FC
DATA &H0000,&H03FC,&H0000,&H03FC,&H0000,&H03FC,&H0000,&H03FC
DATA &H0000,&H03FC,&H0000,&H03FC,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H1FF8,&H8000,&H1FFF,&H8000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H03FC,&H0000,&H03FC
DATA &H0000,&H03FC,&H0000,&H03FC,&H0000,&H03FC,&H0000,&H03FC
DATA &H0000,&H03FC,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H03FC,&H0000,&H03FC,&H0000,&H03FC,&H0000,&H03FC
DATA &H0000,&H03FC,&H0000,&H03FC,&H0000,&H03FC,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H1FF8,&H0000,&H1FFF
DATA &H8000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000

'  AmigaBASIC, Array Size= 243 Width= 46 Height= 40 Colors= 4
'  am4
am4:
DATA &H002E,&H0028,&H0002,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0001
DATA &HFFFF,&H8000,&H0001,&HFFFF,&H8000,&H0001,&HFFFF,&H8000
DATA &H0001,&HFFFF,&H8000,&H0001,&HFFFF,&H8000,&H0001,&HFFFF
DATA &H8000,&H0001,&HFFFF,&H8000,&H0001,&HFFFF,&H8000,&H0001
DATA &HFFFF,&H8000,&H0001,&HFFFF,&H8000,&H0001,&HFFFF,&H8000
DATA &H0001,&HFFFF,&H8000,&H0001,&HFFFF,&H8000,&H0001,&HFFFF
DATA &H8000,&H0001,&HFFFF,&H8000,&H0001,&HFFFF,&H8000,&H0001
DATA &HFFFF,&H8000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H1FFF,&HFFFF,&HFFE0,&H1000,&H0000
DATA &H0020,&H1000,&H0000,&H0020,&H1000,&H0000,&H0020,&H1000
DATA &H0000,&H3FA0,&H1000,&H0000,&H20A0,&H1000,&H0000,&H20A0
DATA &H1000,&H0000,&H20A0,&H1000,&H0000,&H3FA0,&H1000,&H0000
DATA &H0020,&H1000,&H0000,&H0020,&H1FFF,&HFFFF,&HFFE0,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&HFFFF,&H0000,&H0000,&HFFFF,&H0000
DATA &H0000,&HFFFF,&H0000,&H0000,&HFFFF,&H0000,&H0000,&HFFFF
DATA &H0000,&H0000,&HFFFF,&H0000,&H0000,&HFFFF,&H0000,&H0000
DATA &HFFFF,&H0000,&H0000,&HFFFF,&H0000,&H0000,&HFFFF,&H0000
DATA &H0000,&HFFFF,&H0000,&H0000,&HFFFF,&H0000,&H0000,&HFFFF
DATA &H0000,&H0000,&HFFFF,&H0000,&H0000,&HFFFF,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H1F00,&H0000,&H0000,&H1F00
DATA &H0000,&H0000,&H1F00,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000

'  AmigaBASIC, Array Size= 126 Width= 46 Height= 41 Colors= 2
'  am2
am2:
DATA &H002E,&H0029,&H0001,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0001
DATA &HFFFF,&H8000,&H0001,&H0000,&H8000,&H0001,&H0000,&H8000
DATA &H0001,&H0000,&H8000,&H0001,&H0000,&H8000,&H0001,&H0000
DATA &H8000,&H0001,&H0000,&H8000,&H0001,&H0000,&H8000,&H0001
DATA &H0000,&H8000,&H0001,&H0000,&H8000,&H0001,&H0000,&H8000
DATA &H0001,&H0000,&H8000,&H0001,&H0000,&H8000,&H0001,&H0000
DATA &H8000,&H0001,&H0000,&H8000,&H0001,&H0000,&H8000,&H0001
DATA &HFFFF,&H8000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H1FFF,&HFFFF,&HFFE0,&H1000,&H0000
DATA &H0020,&H1000,&H0000,&H0020,&H1000,&H0000,&H0020,&H1000
DATA &H0000,&H3FA0,&H1000,&H0000,&H20A0,&H1000,&H0000,&H20A0
DATA &H1000,&H0000,&H20A0,&H1000,&H0000,&H3FA0,&H1000,&H0000
DATA &H0020,&H1000,&H0000,&H0020,&H1FFF,&HFFFF,&HFFE0,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000

 

    '  AmigaBASIC, Array Size= 151 Width= 16 Height= 37 Colors= 16
    '  cross16
    cross16:
    DATA &H0010,&H0025,&H0004,&H0180,&H0180,&H0180,&H0180,&H0180
    DATA &H0180,&H0180,&H0180,&H0180,&H0180,&H0180,&H0180,&H0180
    DATA &H0180,&H0180,&H0180,&HFFFF,&HFFFF,&H0180,&H0180,&H0180
    DATA &H0180,&H0180,&H0180,&H0180,&H0180,&H0180,&H0180,&H0180
    DATA &H0180,&H0180,&H0180,&H0180,&H0180,&H0180,&H0180,&H0180
    DATA &H03C0,&H03C0,&H03C0,&H03C0,&H03C0,&H03C0,&H03C0,&H03C0
    DATA &H03C0,&H03C0,&H03C0,&H03C0,&H03C0,&H03C0,&H03C0,&HFFFF
    DATA &HFFFF,&HFFFF,&HFFFF,&H0380,&H0380,&H0380,&H0380,&H0380
    DATA &H0380,&H0380,&H0380,&H0380,&H0380,&H0380,&H0380,&H0380
    DATA &H0380,&H0380,&H0380,&H0380,&H0380,&H0000,&H0000,&H0000
    DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
    DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
    DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
    DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
    DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
    DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
    DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
    DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
    DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000

'  AmigaBASIC, Array Size= 303 Width= 18 Height= 30 Colors= 32
'  box32
box32:
DATA &H0012,&H001E,&H0005,&H0000,&H0000,&H0000,&H0000,&H7C3C
DATA &H0000,&H7C3C,&H0000,&H7C3C,&H0000,&H03C3,&H8000,&H03C3
DATA &H8000,&H03C3,&H8000,&H7C3C,&H0000,&H7C3C,&H0000,&H7C3C
DATA &H0000,&H03C3,&H8000,&H03C3,&H8000,&H03C3,&H8000,&H7C3C
DATA &H0000,&H7C3C,&H0000,&H7C3C,&H0000,&H03C0,&H0000,&H03C0
DATA &H0000,&H03C0,&H0000,&H7C3C,&H0000,&H7C3C,&H0000,&H7C3C
DATA &H0000,&H03C0,&H0000,&H03C0,&H0000,&H03C0,&H0000,&H7C3C
DATA &H0000,&H7C3C,&H0000,&H7C3C,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H03FC,&H0000,&H03FC,&H0000,&H03FC
DATA &H0000,&H7FC0,&H0000,&H7FC0,&H0000,&H7FC0,&H0000,&H7C03
DATA &H8000,&H7C03,&H8000,&H7C03,&H8000,&H003F,&H8000,&H003F
DATA &H8000,&H003F,&H8000,&H03FC,&H0000,&H03FC,&H0000,&H03FC
DATA &H0000,&H7FC0,&H0000,&H7FC0,&H0000,&H7FC0,&H0000,&H7C00
DATA &H0000,&H7C00,&H0000,&H7C00,&H0000,&H003C,&H0000,&H003C
DATA &H0000,&H003C,&H0000,&H03FC,&H0000,&H03FC,&H0000,&H03FC
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0003
DATA &H8000,&H0003,&H8000,&H0003,&H8000,&H003F,&H8000,&H003F
DATA &H8000,&H003F,&H8000,&H03FF,&H8000,&H03FF,&H8000,&H03FF
DATA &H8000,&H7FFF,&H8000,&H7FFF,&H8000,&H7FFF,&H8000,&H7FFC
DATA &H0000,&H7FFC,&H0000,&H7FFC,&H0000,&H7FC0,&H0000,&H7FC0
DATA &H0000,&H7FC0,&H0000,&H7C00,&H0000,&H7C00,&H0000,&H7C00
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H03C3,&H8000,&H03C3,&H8000,&H03C3
DATA &H8000,&H03C3,&H8000,&H03C3,&H8000,&H03C3,&H8000,&H03C3
DATA &H8000,&H03C3,&H8000,&H03C3,&H8000,&H03C3,&H8000,&H03C3
DATA &H8000,&H03C3,&H8000,&H03C0,&H0000,&H03C0,&H0000,&H03C0
DATA &H0000,&H03FC,&H0000,&H03FC,&H0000,&H03FC,&H0000,&H003C
DATA &H0000,&H003C,&H0000,&H003C,&H0000,&H7C3C,&H0000,&H7C3C
DATA &H0000,&H7C3C,&H0000,&H7C3C,&H0000,&H7C3C,&H0000,&H7C3C
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H003F
DATA &H8000,&H003F,&H8000,&H003F,&H8000,&H003F,&H8000,&H003F
DATA &H8000,&H003F,&H8000,&H003F,&H8000,&H003F,&H8000,&H003F
DATA &H8000,&H003F,&H8000,&H003F,&H8000,&H003F,&H8000,&H003C
DATA &H0000,&H003C,&H0000,&H003C,&H0000,&H003C,&H0000,&H003C
DATA &H0000,&H003C,&H0000,&H03FC,&H0000,&H03FC,&H0000,&H03FC
DATA &H0000,&H03FC,&H0000,&H03FC,&H0000,&H03FC,&H0000,&H03FC
DATA &H0000,&H03FC,&H0000,&H03FC,&H0000,&H0000,&H0000

'  AmigaBASIC, Array Size= 459 Width= 42 Height= 38 Colors= 16
'  a
a:
DATA &H002A,&H0026,&H0004,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&HFFE0,&H0000,&H0000,&H0000,&H0000,&H0001
DATA &HFFF0,&H0000,&H0000,&H0000,&H0000,&H0001,&HFFF0,&H0000
DATA &H0000,&H0000,&H0000,&H0003,&HFFF8,&H0000,&H0000,&H0000
DATA &H0000,&H0007,&HFFFC,&H0000,&H0000,&H0000,&H0000,&H0007
DATA &HCFFC,&H0000,&H0000,&H0000,&H0000,&H000F,&H87FE,&H0000
DATA &H0000,&H0000,&H0000,&H001F,&H87FF,&H0000,&H0000,&H0000
DATA &H0000,&H001F,&H03FF,&H0000,&H0000,&H0000,&H0000,&H003E
DATA &H01FF,&H8000,&H0000,&H0000,&H0000,&H007F,&HFFFF,&HC000
DATA &H0000,&H0000,&H0000,&H007F,&HFFFF,&HC000,&H0000,&H0000
DATA &H0000,&H00FC,&H007F,&HE000,&H0000,&H0000,&H0000,&H01F8
DATA &H003F,&HF000,&H0000,&H0000,&H0000,&H03FC,&H007F,&HF800
DATA &H0000,&H0000,&H0000,&H3FFF,&HCFFF,&HFF80,&H0000,&H0000
DATA &H0000,&H3FFF,&HCFFF,&HFF80,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000,&H0000
DATA &H0000,&H0000,&H0000
