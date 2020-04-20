
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>3MF Project: What's In A GIF - Animation and Transparency</title>
	<script type="text/javascript"></script>
	<link rel="stylesheet" href="proj.css" />
	<style type="text/css">
	.byte {font-family: Courier, fixed;
		padding: .2em}
	.gif_header {background-color: #f9E89D}
	.gif_screen {background-color: #C8DBD9}
	.gif_color {background-color: #E1E1E1}
	.gif_graphic {background-color: #F9EB9D}
	.gif_imgdesc {background-color: #C2D1DC}
	.gif_imgdata {background-color: #D0C4C4}
	.gif_trailer {background-color: #f9E89D}
	.gif_ext {background-color: #D0CFAE}
	#global_color_size {margin-left: auto; margin-right:auto; border:1px solid black;}
	#global_color_size td {text-align:center;}
	</style>
</head>
<body>

<div id="nav"><a href="../index.html">back to main lab page</a></div>
<div id="body">


<h1>Project: <span class="projname">What's In A GIF - Animation and Transparency</span></h1>
<nav><a href="lzw_image_data.asp" class="prev">Prev</a> - <a class="index" href="./">Index</a> - <a class="next" href="gif_explorer.asp">Next</a></nav>

<div class="projdesc">
	<p>
	In addition to being able to store simple image data like some old bmp file,
	GIF files (specifically GIF89a files) allow for some special features. Tricks
	such as transparency and animation can be accomplished with the
	help of the Graphics Control Extension block. Here's a sample of what this
	block looks like:
	</p>
	<p style="text-align:center"><img src="images/graphic_control_ext.gif" alt="GIF graphics control ext block layout" style="border: 1px solid black" /></p>
	<p>
	I'll show you how to manipulate the bytes in this block to achieve these
	special effects.
	</p>

	<h2><a name="animation">Animation</a></h2>
	<p>
	Cartoons are created by animators who draw a bunch of pictures, each slightly
	different from the one before, which, when rapidly shown one after the other,
	give the illusion of motion. Animation in GIF images is achieved in much the same
	way. Multiple images may be stored in the same file and you can tell the
	computer how much time to wait before showing the next image. Let's walk though
	the parts that make up this simple traffic light animation.
	</p>
	<p style="text-align:center"><img src="images/sample_2_animation.gif" alt="sample animated traffic light" / WIDTH="11" HEIGHT="29"></p>
	<p>
	<span class="byte gif_header"> 47 </span><span class="byte gif_header"> 49 </span><span class="byte gif_header"> 46 </span><span class="byte gif_header"> 38 </span><span class="byte gif_header"> 39 </span><span class="byte gif_header"> 61 </span><span class="byte gif_screen"> 0B </span><span class="byte gif_screen"> 00 </span><span class="byte gif_screen"> 1D </span><span class="byte gif_screen"> 00 </span><span class="byte gif_screen"> A2 </span><span class="byte gif_screen"> 05 </span><span class="byte gif_screen"> 00 </span><span class="byte gif_color"> FF </span><span class="byte gif_color"> 00 </span><span class="byte gif_color"> 00 </span><span class="byte gif_color"> 00 </span><span class="byte gif_color"> FF </span><span class="byte gif_color"> 00 </span><span class="byte gif_color"> FF </span><span class="byte gif_color"> FF </span><span class="byte gif_color"> 00 </span><span class="byte gif_color"> 8E </span><span class="byte gif_color"> 8E </span><span class="byte gif_color"> 8E </span><span class="byte gif_color"> 00 </span><span class="byte gif_color"> 00 </span><span class="byte gif_color"> 00 </span><span class="byte gif_color"> FF </span><span class="byte gif_color"> FF </span><span class="byte gif_color"> FF </span><span class="byte gif_color"> 00 </span><span class="byte gif_color"> 00 </span><span class="byte gif_color"> 00 </span><span class="byte gif_color"> 00 </span><span class="byte gif_color"> 00 </span><span class="byte gif_color"> 00 </span><span class="byte gif_ext"> 21 </span><span class="byte gif_ext"> FF </span><span class="byte gif_ext"> 0B </span><span class="byte gif_ext"> 4E </span><span class="byte gif_ext"> 45 </span><span class="byte gif_ext"> 54 </span><span class="byte gif_ext"> 53 </span><span class="byte gif_ext"> 43 </span><span class="byte gif_ext"> 41 </span><span class="byte gif_ext"> 50 </span><span class="byte gif_ext"> 45 </span><span class="byte gif_ext"> 32 </span><span class="byte gif_ext"> 2E </span><span class="byte gif_ext"> 30 </span><span class="byte gif_ext"> 03 </span><span class="byte gif_ext"> 01 </span><span class="byte gif_ext"> 00 </span><span class="byte gif_ext"> 00 </span><span class="byte gif_ext"> 00 </span><span class="byte gif_graphic"> 21 </span><span class="byte gif_graphic"> F9 </span><span class="byte gif_graphic"> 04 </span><span class="byte gif_graphic"> 04 </span><span class="byte gif_graphic"> 64 </span><span class="byte gif_graphic"> 00 </span><span class="byte gif_graphic"> 00 </span><span class="byte gif_graphic"> 00 </span><span class="byte gif_imgdesc"> 2C </span><span class="byte gif_imgdesc"> 00 </span><span class="byte gif_imgdesc"> 00 </span><span class="byte gif_imgdesc"> 00 </span><span class="byte gif_imgdesc"> 00 </span><span class="byte gif_imgdesc"> 0B </span><span class="byte gif_imgdesc"> 00 </span><span class="byte gif_imgdesc"> 1D </span><span class="byte gif_imgdesc"> 00 </span><span class="byte gif_imgdesc"> 00 </span><span class="byte gif_imgdata"> 03 </span><span class="byte gif_imgdata"> 30 </span><span class="byte gif_imgdata"> 48 </span><span class="byte gif_imgdata"> BA </span><span class="byte gif_imgdata"> DC </span><span class="byte gif_imgdata"> DE </span><span class="byte gif_imgdata"> 23 </span><span class="byte gif_imgdata"> BE </span><span class="byte gif_imgdata"> 48 </span><span class="byte gif_imgdata"> 21 </span><span class="byte gif_imgdata"> AD </span><span class="byte gif_imgdata"> EB </span><span class="byte gif_imgdata"> 62 </span><span class="byte gif_imgdata"> A5 </span><span class="byte gif_imgdata"> 25 </span><span class="byte gif_imgdata"> D3 </span><span class="byte gif_imgdata"> 93 </span><span class="byte gif_imgdata"> F7 </span><span class="byte gif_imgdata"> 8C </span><span class="byte gif_imgdata"> E4 </span><span class="byte gif_imgdata"> 27 </span><span class="byte gif_imgdata"> 9A </span><span class="byte gif_imgdata"> 1B </span><span class="byte gif_imgdata"> D7 </span><span class="byte gif_imgdata"> A1 </span><span class="byte gif_imgdata"> 17 </span><span class="byte gif_imgdata"> 9B </span><span class="byte gif_imgdata"> 1E </span><span class="byte gif_imgdata"> A0 </span><span class="byte gif_imgdata"> F3 </span><span class="byte gif_imgdata"> 96 </span><span class="byte gif_imgdata"> 34 </span><span class="byte gif_imgdata"> 13 </span><span class="byte gif_imgdata"> DC </span><span class="byte gif_imgdata"> CF </span><span class="byte gif_imgdata"> AD </span><span class="byte gif_imgdata"> 37 </span><span class="byte gif_imgdata"> 7A </span><span class="byte gif_imgdata"> 6F </span><span class="byte gif_imgdata"> F7 </span><span class="byte gif_imgdata"> B8 </span><span class="byte gif_imgdata"> 05 </span><span class="byte gif_imgdata"> 30 </span><span class="byte gif_imgdata"> 28 </span><span class="byte gif_imgdata"> F4 </span><span class="byte gif_imgdata"> 39 </span><span class="byte gif_imgdata"> 76 </span><span class="byte gif_imgdata"> B5 </span><span class="byte gif_imgdata"> 64 </span><span class="byte gif_imgdata"> 02 </span><span class="byte gif_imgdata"> 00 </span><span class="byte gif_graphic"> 21 </span><span class="byte gif_graphic"> F9 </span><span class="byte gif_graphic"> 04 </span><span class="byte gif_graphic"> 04 </span><span class="byte gif_graphic"> 32 </span><span class="byte gif_graphic"> 00 </span><span class="byte gif_graphic"> 00 </span><span class="byte gif_graphic"> 00 </span><span class="byte gif_imgdesc"> 2C </span><span class="byte gif_imgdesc"> 02 </span><span class="byte gif_imgdesc"> 00 </span><span class="byte gif_imgdesc"> 0B </span><span class="byte gif_imgdesc"> 00 </span><span class="byte gif_imgdesc"> 07 </span><span class="byte gif_imgdesc"> 00 </span><span class="byte gif_imgdesc"> 10 </span><span class="byte gif_imgdesc"> 00 </span><span class="byte gif_imgdesc"> 00 </span><span class="byte gif_imgdata"> 03 </span><span class="byte gif_imgdata"> 19 </span><span class="byte gif_imgdata"> 78 </span><span class="byte gif_imgdata"> 27 </span><span class="byte gif_imgdata"> AC </span><span class="byte gif_imgdata"> CB </span><span class="byte gif_imgdata"> 0D </span><span class="byte gif_imgdata"> CA </span><span class="byte gif_imgdata"> 49 </span><span class="byte gif_imgdata"> E1 </span><span class="byte gif_imgdata"> B3 </span><span class="byte gif_imgdata"> 0A </span><span class="byte gif_imgdata"> BB </span><span class="byte gif_imgdata"> CD </span><span class="byte gif_imgdata"> F7 </span><span class="byte gif_imgdata"> F8 </span><span class="byte gif_imgdata"> CE </span><span class="byte gif_imgdata"> 27 </span><span class="byte gif_imgdata"> 1E </span><span class="byte gif_imgdata"> 62 </span><span class="byte gif_imgdata"> 69 </span><span class="byte gif_imgdata"> 9E </span><span class="byte gif_imgdata"> A3 </span><span class="byte gif_imgdata"> 19 </span><span class="byte gif_imgdata"> 82 </span><span class="byte gif_imgdata"> 47 </span><span class="byte gif_imgdata"> 02 </span><span class="byte gif_imgdata"> 00 </span><span class="byte gif_graphic"> 21 </span><span class="byte gif_graphic"> F9 </span><span class="byte gif_graphic"> 04 </span><span class="byte gif_graphic"> 04 </span><span class="byte gif_graphic"> 64 </span><span class="byte gif_graphic"> 00 </span><span class="byte gif_graphic"> 00 </span><span class="byte gif_graphic"> 00 </span><span class="byte gif_imgdesc"> 2C </span><span class="byte gif_imgdesc"> 02 </span><span class="byte gif_imgdesc"> 00 </span><span class="byte gif_imgdesc"> 02 </span><span class="byte gif_imgdesc"> 00 </span><span class="byte gif_imgdesc"> 07 </span><span class="byte gif_imgdesc"> 00 </span><span class="byte gif_imgdesc"> 10 </span><span class="byte gif_imgdesc"> 00 </span><span class="byte gif_imgdesc"> 00 </span><span class="byte gif_imgdata"> 03 </span><span class="byte gif_imgdata"> 19 </span><span class="byte gif_imgdata"> 78 </span><span class="byte gif_imgdata"> 07 </span><span class="byte gif_imgdata"> AC </span><span class="byte gif_imgdata"> CB </span><span class="byte gif_imgdata"> 0D </span><span class="byte gif_imgdata"> CA </span><span class="byte gif_imgdata"> 49 </span><span class="byte gif_imgdata"> E1 </span><span class="byte gif_imgdata"> B3 </span><span class="byte gif_imgdata"> 0A </span><span class="byte gif_imgdata"> BB </span><span class="byte gif_imgdata"> CD </span><span class="byte gif_imgdata"> F7 </span><span class="byte gif_imgdata"> F8 </span><span class="byte gif_imgdata"> CE </span><span class="byte gif_imgdata"> 27 </span><span class="byte gif_imgdata"> 1E </span><span class="byte gif_imgdata"> 62 </span><span class="byte gif_imgdata"> 69 </span><span class="byte gif_imgdata"> 9E </span><span class="byte gif_imgdata"> A3 </span><span class="byte gif_imgdata"> 19 </span><span class="byte gif_imgdata"> 82 </span><span class="byte gif_imgdata"> 45 </span><span class="byte gif_imgdata"> 02 </span><span class="byte gif_imgdata"> 00 </span><span class="byte gif_trailer"> 3B </span>
	</p>
	<p>
	This file is similar to the ones we've previously encountered. The bytes start
	out with the GIF header. Next we have a
	<a href="bits_and_bytes.asp#logical_screen_descriptor_block">logical screen descriptor</a>
	which tells us that our image is 11px by 29 px and will have a global color table
	with 8 colors in it (of which we only really need 5). Immediately after, follows
	the global color table which tells us what those colors are (0=red, 1=green,
	2=yellow, 3=light gray, 4=black, 5=white, 6=black [not used], 7=black [not used] ).
	</p>
	<p>
	Next we encounter an
	<a href="bits_and_bytes.asp#application_extension_block">application extension block</a>.
	This is this block that causes our animation to repeat rather than play once
	and stop. The first three bytes tell us we are looking at (1) an extension
	block (2) of type &quot;application&quot; which is followed by (3) 11 bytes of fixed length
	data. These 11 bytes contain the ASCII character codes for &quot;NETSCAPE2.0&quot;. Then
	begins the actual &quot;application data&quot; which is contained in sub-blocks. There are
	two values that are stored in these sub-blocks. The first value is always
	the byte <span class="byte">01</span>. Then we have a value in the unsigned
	(lo-hi byte) format that says how many times the animation should repeat. You
	can see that our sample image has a value of 0; this means the animation
	should loop forever. These three bytes are preceded by the <span class="byte">03</span>
	that lets the decoder know that three bytes of data follow, and they are terminated
	by <span class="byte">00</span>, the block terminator.
	</p>
	<p>
	This very basic animation is essentially made up of three different &quot;scenes&quot;.
	The first is the one with the green light lit, the second with the yellow, and the
	last with the red. You should be able to see three separate chunks of image data
	in the bytes above.
	</p>
	<table style="margin-left: auto;margin-right: auto">
		<tr><th>1</th><th>2</th><th>3</th></tr>
		<tr>
		<td><img src="images/sample_2_animation_green.gif" alt="scene 1: green light" width="11" height="29"/></td>
		<td><img src="images/sample_2_animation_yellow.gif" alt="scene 2: yellow light" width="11" height="29"/></td>
		<td><img src="images/sample_2_animation_red.gif" alt="scene 3: red light" width="11" height="29"/></td>
		</tr>
	</table>
	<p>
	The first chunk begins immediately after the application extension block.
	It is there we encounter our first graphic control extension. As with all
	extensions, it begins with <span class="byte">21</span>. Next, the type
	specific label for the graphic control type of extension is
	<span class="byte">F9</span>. Next we see the byte size of the
	data in the block; this should always be <span class="byte">04</span>. The
	first of these four data blocks is a packed field.
	</p>
	<p>
	The packed field stores three values. The first three (highest) bits
	are &quot;reserved for future use&quot; so those have been left as
	zeros. The next three bits indicate the
	disposal method. The <em>disposal method</em> specifies what happens to
	the current image data when you move onto the next. We have three bits which
	means we can represent a number between 0 and 7. Our sample animated
	image has a value of 1 which tells the decoder to leave the image
	in place and draw the next image on top of it. A value of 2 would have
	meant that the canvas should be restored to the background color (as
	indicated by the logical screen descriptor). A value of 3 is defined to mean
	that the decoder should restore the canvas to its previous state
	before the current image was drawn. I don't believe that this value is
	widely supported but haven't had the chance to test it out. The behavior
	for values 4-7 are yet to be defined. If this image were not animated,
	these bits would have been set to 0 which indicates that do not wish to specify
	a disposal method. The seventh bit in they byte is the <em>user input
	flag</em>. When set to 1, that means that the decoder will wait for
	some sort of &quot;input&quot; from the person viewing the image before
	moving on to the next scene. I'm guessing it's highly unlikely
	that you will encounter any other value that 0 for this bit.
	The final bit is the transparency flag. We will go into more
	detail about transparency in
	<a href="#transparency">the next section</a>. Since this image isn't
	using any transparency, we see this bit has been left at 0.
	</p>
	<p>
	The next two bytes are the delay time. This value is in the usual
	unsigned format as all the other integers in the file. This number
	represents the number of hundredths of a second to wait before moving
	on to the next scene. We see that our sample image has specified
	a value of 100 (<span class="byte">64</span> <span class="byte">00</span>)
	in the first graphics control block which means we would wait 1 second
	before changing our green light to yellow.
	</p>
	<p>
	Our graphics control extension block ends with the block
	terminator <span class="byte">00</span>. You will notice this
	type of block appearing two more times in this image, the second
	instance differing only in the delay time (the yellow light only
	stays up for half a second).
	</p>
	</p>
	The next chunk is an image descriptor. The block declares that it
	will be drawing an image starting at the top left corner and taking
	up the whole canvas (11px x 29px). This block is followed by the image
	data that contains all the codes to draw the first scene, the one with
	the green light on.
	</p>
	<table style="margin-left: auto;margin-right: auto; text-align: center">
		<tr><th>Green</th><th>(Difference)</th><th>Yellow</th></tr>
		<tr>
		<td><img src="images/sample_2_green_large.gif" alt="green light enlarged" width="33" height="87"/></td>
		<td><img src="images/sample_2_green_yellow_diff.gif" alt="difference between green and yellow images"width="33" height="87"/></td>
		<td><img src="images/sample_2_yellow_large.gif" alt="yellow light enlarged" width="33" height="87"/></td>
		</tr>
	</table>
	<p>
	If we compare the first and the second scene, we see they share many
	of the same pixel color values. Rather than redrawing the whole canvas,
	we can specify just the part that changes (that is, the smallest
	rectangle that covers the part that changes). You'll see that the
	image descriptor before the second block of image data specifies
	that it will start at the pixel at (2, 11) and draws a box that's
	7px wide by 16px tall. This is just large enough to cover the bottom two
	lights. The works because we chose the &quot;do not dispose&quot; disposal
	method for out graphics control extension block. In the same way,
	the third and final image data block only renders the top two circles
	to both fill in the red and cover up the yellow.
	</p>



	<h2><a name="transparency">Transparency</a></h2>
	<p>
	Normally, GIF images are rectangles that cover up what ever background
	may be beneath them. Transparency allows you to &quot;see though&quot; the image
	to whatever is below. This is a very simple trick to pull off in a GIF
	image. You can set up one color in your color table that is converted
	to &quot;invisible ink.&quot; Then, as the image is drawn, whenever this special
	color is encountered, the background is allowed to show through.
	</p>
	<p>
	There are only two pieces of data we have to set to pull this off. First
	we must set the Transparency Color Flag to 1. This is the lowest bit
	in the packed byte of the Graphic Control Extension. This will tell
	the decoder that we want our image to have a transparent component.
	Secondly we must tell the decoder which color we want to use as our
	invisible ink. The decoder will then all you to see thought every pixel
	that contains this color. Therefore make sure it's not a color that you
	are using else where in your image. The color you choose must be in
	the active color table and you specify its value in the Transparent Color
	Index byte by setting this value to the index of the color in the color
	table.
	</p>
	<p>
	Let's demonstrate this by revisiting the sample image we used
	in <a href="bits_and_bytes.asp">Bits and Bytes</a>. We will update this
	file to make the white center part transparent. Let's start creating
	the Graphic Control Extension block that will do this for us. Again we
	start with the <span class="byte">21</span> <span class="byte">F9</span>
	<span class="byte">04</span> punch. In the next byte, we need to flip
	the transparent color flag to 1 (we can leave the others at zero) so
	this whole byte is simply <span class="byte">01</span>. The next two
	bytes can be left at zero.
	</p>
	<p>
	We must now specify which color to disappear.
	Recall that our sample image had the following global color table:
	</p>
	<table style="margin-left: auto; margin-right: auto">
		<tr><th>Index</th><th>Color</th></tr>
		<tr><td>0</td><td><span style="color:#FFFFFF; background: #000000; font-weight: bold">White</span></td></tr>
		<tr><td>1</td><td><span style="color:#FF0000; font-weight: bold">Red</span></td></tr>
		<tr><td>2</td><td><span style="color:#0000FF; font-weight: bold">Blue</span></td></tr>
		<tr><td>3</td><td><span style="font-weight: bold">Black</span></td></tr>
	</table>
	<p>
 	We already know what we want to make all the white sections transparent.
	The color white has an index of 0. Therefore we will specify a value
	of <span class="byte">00</span> for the transparent color index block.
	Had we wanted to make the red transparent we would have used
	<span class="byte">01</span>, or <span class="byte">02</span> for blue.
	Lastly we tack on the block terminator of <span class="byte">00</span>
	and we're done. We have created the following block:
	</p>
	<p><span class="byte gif_graphic"> 21 </span><span class="byte gif_graphic"> F9 </span><span class="byte gif_graphic"> 04 </span><span class="byte gif_graphic"> 01 </span><span class="byte gif_graphic"> 00 </span><span class="byte gif_graphic"> 00 </span><span class="byte gif_graphic"> 00 </span><span class="byte gif_graphic"> 00 </span></p>
	<p>
	Now, all we have to do is plug this into our sample image right before the
	image descriptor. I've placed our original sample image on a black background
	as well as the one we just made so you can see the results. I've also included
	ones where red or blue are transparent. The last three differ by only the
	transparent color index byte.
	</p>
	<table cellpadding="10px" style="text-align: center; margin-left: auto; margin-right: auto">
		<tr>
			<th style="width:25%">Original</th>
			<th style="width:25%">Transparent <br/> White (<span class="byte">00</span>)</th>
			<th style="width:25%">Transparent <br/> Red (<span class="byte">01</span>)</th>
			<th style="width:25%">Transparent <br/> Blue (<span class="byte">02</span>)</th>
		</tr>
		<tr>
			<td style="width:25%; background-color: black"><img src="images/sample_1.gif" alt="previous sample" width="10" height="10"/></td>
			<td style="width:25%; background-color: black"><img src="images/sample_1_trans.gif" alt="transparent white" width="10" height="10"/></td>
			<td style="width:25%; background-color: black"><img src="images/sample_1_trans_red.gif" alt="transparent red" width="10" height="10"/></td>
			<td style="width:25%; background-color: black"><img src="images/sample_1_trans_blue.gif" alt="transparent blue" width="10" height="10"/></td>
		</tr>
	</table>

	<h2>Next: GIF Explorer</h2>
	<p>Now that you have seen how all the parts of a GIF file come together to make an image,
		the last section allows you to decode and browse the contents of any GIF file
		rather than just the sample images I included in this article.
		<a href="gif_explorer.asp">Continue...</a></p>

</div>


<div style="text-align:center; margin-top: 10px; padding-top: 10px; border-top: #cecece 1px solid">
<a href="../../index.html">home</a> -
<a href="https://github.com/MrFlick/whats-in-a-gif">github</a> -
<a href="mailto:me@matthewflickinger.com">me@matthewflickinger.com</a>
</div>

</div>


</body>

</html>

<!-- Localized -->
