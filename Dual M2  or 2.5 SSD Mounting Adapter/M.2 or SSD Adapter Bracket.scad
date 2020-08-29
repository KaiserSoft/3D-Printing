/*
    Parametric Dual M.2 / SSD to 3.5" Adapter
        * You need to export one bracket per side
    
    Source: https://github.com/KaiserSoft/3D-Printing/tree/master/Dual%20M2%20%20or%202.5%20SSD%20Mounting%20Adapter
    
    License: CC0 1.0 Universal (CC0 1.0) Public Domain Dedication
    Designed: 2019 by Mirko Kaiser in Stuttgart, Germany
*/

/* [User Config Options] */
// You need one bracket for each side
Bracket = "left"; // [ left, right, stabilizer, lockplate ]

// Thickness of the PCB or SSD
Slot1_Height = 7; // [ 1.25:1.25mm Bare PCB, 2:2mm Bare PCB, 5:5mm, 6:6mm, 7:7mm, 8:8mm, 9:9mm, 10:10mm, 11:11mm ]
// Length of PCB or SSD - WARNING: mSATA will not mix with other settings!
Slot1_Length = 98; // [ 48:48 mSATA PCB, 98:98mm M.2 PCB, 101:101mm SSD ]
// Adjust the depth if your PCB has components close to the edge. WARNING setting this below 3mm will change the width of the part and the depth of the other slot to ensure that the total width stays within 3.5"
Slot1_Depth = 3; // [ 1:1mm, 2:2mm, 3:3mm, 4:4mm ]

// Thickness of the PCB or SSD - WARNING: mSATA will not mix with other settings!
Slot2_Height = 7; // [ 1.25:1.25mm Bare PCB, 2:2mm Bare PCB, 5:5mm, 6:6mm, 7:7mm, 8:8mm, 9:9mm, 10:10mm, 11:11mm ]
// Length of PCB or SSD
Slot2_Length = 98; // [ 48:48 mSATA PCB, 98:98mm M.2 PCB, 101:101mm SSD ]
// Adjust the depth if your PCB has components close to the edge. WARNING setting this below 3mm will change the width of the part and the depth of the other slot to ensure that the total width stays within 3.5"
Slot2_Depth = 3; // [ 1:1mm, 2:2mm, 3:3mm, 4:4mm ]
// Ad mounting holes for the locking plate
Lock_Plate = 1; // [0:no, 1:yes]
// Add stabilizing plate slot
Stabilizer_Slot = 1; // [0:no, 1:yes]
// Width of the mSATA PCB
mSATAPCB_Width = 57.5; // [ 43:0.5:70 ]

/* [Bracket Dimensions] */
BracketLength = 110;
BracketHeight = 25;
BracketWidth = 19;
// width of a 3.5" slot
TotalWidth = 101;

/* [3.5" Mounting Holes] */
MountingHolesDiameter = 3.3;
MountingHolesDepth = 12;
MountingHolesDistance = 101;
MountingHolesDistanceBottom = 6;
// in percent
MountingHolesTaper = 1;

/* [Sliding Lock] */
LockHolesDiameter = 3.15;
LockHolesDepth = 15;
LockHolesDistance = 10;
LockHolesSlotLength = 3.5; // + LockHolesDiameter
// in percent
LockHolesTaper = 1;
LockThickness = 1; //in mm
LockCornersDiameter = 3; // in mm


// Adjust Width of block for low PCB clearance
Shallow = ( Slot1_Depth < Slot2_Depth ) ? Slot1_Depth : Slot2_Depth;
BracketWidthUsed = ( Slot1_Depth < 3 || Slot2_Depth < 3 )? BracketWidth - (3 - Shallow) : BracketWidth;
Slot1DepthUsed = ( Slot1_Depth < 3 ) ? Slot1_Depth : Slot1_Depth + (3 - Shallow) ;
Slot2DepthUsed = ( Slot2_Depth < 3 ) ? Slot2_Depth : Slot2_Depth + (3 - Shallow);
if( Slot1_Depth < 3 || Slot2_Depth < 3 && Slot1_Depth != Slot2_Depth ){
    echo("WARNING: slot depth below 3mm and not equal depth!");
}

//Adjust Width for mSATA slots
mSATAWidthModifier = (TotalWidth - mSATAPCB_Width - BracketWidthUsed*2)/2 + Shallow;
BracketWidthUsedmSATA = ( Slot1_Length == 48 || Slot2_Length == 48 ) ? BracketWidthUsed + mSATAWidthModifier : BracketWidthUsed;
/* variables end */





/* create bodies */
if( Bracket == "left" ) {
    mirror( [1, 0 ,0] ){ 
        difference(){
            if ( Slot1_Length == 48 || Slot2_Length == 48 ){
                mountingBlock(BracketWidthUsedmSATA);
            }else{
                mountingBlock(BracketWidthUsed);
            }
            if( Stabilizer_Slot == 1 ){
                makeStabilizerSlot( BracketWidth-2.5, 4, MountingHolesDistance-(BracketWidth- BracketWidth/3)*2);
            }
        }
    }
    
}else if( Bracket == "right" ) {
    difference(){
        if ( Slot1_Length == 48 || Slot2_Length == 48 ){
            mountingBlock(BracketWidthUsedmSATA);
        }else{
            mountingBlock(BracketWidthUsed);
        }
        if( Stabilizer_Slot == 1 ){
            makeStabilizerSlot(BracketWidth-2.5, 4, MountingHolesDistance-(BracketWidth-BracketWidth/3)*2);
        }
    }
    
}else if( Bracket == "stabilizer" ){
    rotate([ 90, 0, 180])
    makeStabilizer(BracketWidth-2.5-0.2, 4-0.2, MountingHolesDistance-(BracketWidth-BracketWidth/3)*2 - 0.4);
    
}else if( Bracket == "lockplate" ){
    rotate( [ 90, 0, 0 ]){ //final rotation for proper print orientation
    difference(){
        sliderBody();
            screwSlot( 4, BracketHeight/2 + LockHolesDistance-2.5 );
            screwSlot( 4, BracketHeight/2 - LockHolesDistance+LockHolesDistance-2.5 );
        }
    }
}



/* create Stabilizer slot cut out in block */
module makeStabilizerSlot(sWidth, sThick, sLenght){
    if ( Slot1_Length == 48 || Slot2_Length == 48 ){
        translate([ BracketWidth/4, BracketLength-6, (-BracketWidth/3)-mSATAWidthModifier]){
                makeStabilizer(sWidth, sThick, sLenght);
            }
    }else{
        translate([ BracketWidth/4, BracketLength-6, -BracketWidth/3]){
                makeStabilizer(sWidth, sThick, sLenght);
            }
    }
}

/* make Stabilizer bar for cut out and for printing */
module makeStabilizer( sWidth, sThick, sLenght ){
    color ("green") cube([ sWidth, sThick, sLenght ]);
}

/* the entire mounting block */
module mountingBlock( bWidth ){
    rotate( [0, 90, 0 ] ){ //proper rotation for printing
        difference(){
            /* main Bracket */
            cube( [ bWidth, BracketLength, BracketHeight] , false);


            /* bottom slot */
            if( Slot1_Height < 10 ){
                makeSlot( 3, Slot1_Height, Slot1DepthUsed, Slot1_Length );
            }else if( Slot1_Height == 10 ){
                makeSlot( 2, Slot1_Height, Slot1DepthUsed, Slot1_Length );
            }else{
                makeSlot( 1, Slot1_Height, Slot1DepthUsed, Slot1_Length );
            }


            /* top slot */
            if( Slot2_Height < 5 ){
                distance = BracketHeight-7-3;
                makeSlot( distance, Slot2_Height, Slot2DepthUsed, Slot2_Length );
            }else if( Slot2_Height < 10 ){
                distance = BracketHeight-Slot2_Height-3;
                makeSlot( distance, Slot2_Height, Slot2DepthUsed, Slot2_Length );
            }else if( Slot2_Height == 10 ){
                distance = BracketHeight-Slot2_Height-2;
                makeSlot( distance, Slot2_Height, Slot2DepthUsed, Slot2_Length );
            }else{
                distance = BracketHeight-Slot2_Height-1;
                makeSlot( distance, Slot2_Height, Slot2DepthUsed, Slot2_Length );
            }
            

            /* 3.5" mounting holes */
            m3Holes( bWidth );

            /* lock slider mounting holes */
           if( Lock_Plate == 1 ){
            lockSlider();
           }
        }
    }
}



/* lock slider mount */
module lockSlider(){
    for( x=[0:1] ){
       translate([ BracketWidthUsed/2.2, -1, LockHolesDistance + LockHolesDistance * x]) { 
            rotate( [-90, 0, 0] ){
        color ("red") cylinder( $fn=25, 1+LockHolesDepth, d1=LockHolesDiameter, d2=LockHolesDiameter-LockHolesDiameter*(LockHolesTaper/100),false);
            }
        }
    }
}


/* 3.5" mounting holes */
module m3Holes( bWidth ){
    for( x=[0:1] ){
        translate( [bWidth+1,((BracketLength-MountingHolesDistance)/2)+(x*MountingHolesDistance),MountingHolesDistanceBottom]){
            rotate( [0, -90, 0] ){
                color ("blue") cylinder($fn=25, 1+MountingHolesDepth, d1=MountingHolesDiameter, d2=MountingHolesDiameter-MountingHolesDiameter*(MountingHolesTaper/100),false);
            }
        }
    }
}


/* creates a single slot */
module makeSlot( Distance2Bottom, SlotHeight, SlotDepth, SlotLength ){
    translate([ -1, -1, Distance2Bottom]) {
        color ("purple") cube( [ 1+SlotDepth, 1+SlotLength, SlotHeight], false);
    }
}


/* modules for lock plate below */
module sliderBody(){
    Corner = LockCornersDiameter/2;
    hull(){
        translate( [ Corner, 0, Corner ] ){
            rotate( [-90, 0, 0] ){
                color ("green") makeBodyCylinder();
            }
        }
        translate( [ BracketWidth/1.5-Corner, 0, Corner ] ){
            rotate( [-90, 0, 0] ){
                color ("blue") makeBodyCylinder();
            }
        }
        translate( [ Corner, 0, BracketHeight-Corner ] ){
            rotate( [-90, 0, 0] ){
                color ("red") makeBodyCylinder();
            }
        }
        translate( [ BracketWidth/1.5-Corner, 0, BracketHeight-Corner ] ){
            rotate( [-90, 0, 0] ){
                color ("purple") makeBodyCylinder();
            }
        }
    }
}


module makeBodyCylinder(){
    cylinder( $fn=25, LockThickness, d1=LockCornersDiameter, d2=LockCornersDiameter,false);
}

module screwSlot( x, y ){
    translate( [ 0, 0, y ]){
        union(){
            screwHole( x );
            screwHole( x+LockHolesSlotLength );
            screwBlock( x );
        }
    }
}


module screwHole( x ){
    translate( [ x, -1,0 ] ){
        rotate( [-90, 0, 0] ){
            color ("violet") cylinder( $fn=25, 1+LockHolesDepth, d1=LockHolesDiameter, d2=LockHolesDiameter-LockHolesDiameter*(LockHolesTaper/100),false);
            }
        }
}

module screwBlock( x ){
    translate( [x ,-1, LockHolesDiameter/2]){
        rotate( [0, 90, 0] ){
        color("black") 

            cube( [LockHolesDiameter, 1+LockHolesDepth, LockHolesSlotLength ], false);
        }
    }
}