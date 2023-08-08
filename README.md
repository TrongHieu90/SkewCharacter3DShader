# SkewCharacter3DShader
Simple Unity shader to skew / tilt shader of 3d character to match perspective of 2d background / 2d sprites. It makes the 3d character shows more face, more personality.

**Check out my mobile game to view this shader in effect:**<br />
https://play.google.com/store/apps/details?id=com.jumpcat.wizardlegacy<br />
https://apps.apple.com/app/id6450950871<br />

There is no need to change any code in the camera or 2d movement, 2d physics (assuming you are using the default axis of Z pointing forward, Y pointing upward, and x pointing rightward)

**Some known issues:**<br />
Any item put into main character(eg: weapon) will have their view distorted. One way to fix this is to make the weapon a part of main character's skeleton rig.

![skew3dcharactershader](https://github.com/TrongHieu90/SkewCharacter3DShader/assets/20443445/51eea3d0-69dc-43c7-b709-ad6ef3652d50)
