/*
    DIrrlicht - D Bindings for Irrlicht Engine

    Copyright (C) 2014- Danyal Zia (catofdanyal@yahoo.com)

    This software is provided 'as-is', without any express or
    implied warranty. In no event will the authors be held
    liable for any damages arising from the use of this software.

    Permission is granted to anyone to use this software for any purpose,
    including commercial applications, and to alter it and redistribute
    it freely, subject to the following restrictions:

    1. The origin of this software must not be misrepresented;
       you must not claim that you wrote the original software.
       If you use this software in a product, an acknowledgment
       in the product documentation would be appreciated but
       is not required.

    2. Altered source versions must be plainly marked as such,
       and must not be misrepresented as being the original software.

    3. This notice may not be removed or altered from any
       source distribution.
*/

module dirrlicht.gui.guiimage;

import dirrlicht.gui.guienvironment;
import dirrlicht.video.texture;
import dirrlicht.video.color;
import dirrlicht.core.vector2d;
import dirrlicht.core.rect;

interface GUIImage {
    void setImage(Texture texture);
    Texture getImage();
    void setColor(Color col);
    void setScaleImage(bool scale);
    void setUseAlphaChannel(bool use);
    Color getColor();
    bool isImageScaled();
    bool isAlphaChannelUsed();
    void setSourceRect(recti sourceRect);
    recti getSourceRect();
    void setDrawBounds(rectf drawBoundUVs);
    rectf getDrawBounds();
    @property void* c_ptr();
	@property void c_ptr(void* ptr);
}

class CGUIImage : GUIImage {
    this(irr_IGUIImage* ptr) {
    	this.ptr = ptr;
    }
    
    void setImage(Texture texture) {
        irr_IGUIImage_setImage(ptr, texture.ptr);
    }

    Texture getImage() {
        auto tex = irr_IGUIImage_getImage(ptr);
        return new Texture(tex);
    }

    void setColor(Color col) {
        irr_IGUIImage_setColor(ptr, col);
    }

    void setScaleImage(bool scale) {
        irr_IGUIImage_setScaleImage(ptr, scale);
    }

    void setUseAlphaChannel(bool use) {
        irr_IGUIImage_setUseAlphaChannel(ptr, use);
    }

    Color getColor() {
        auto col = irr_IGUIImage_getColor(ptr);
        return Color(col.r, col.g, col.b, col.a);
    }

    bool isImageScaled() {
        return irr_IGUIImage_isImageScaled(ptr);
    }

    bool isAlphaChannelUsed() {
        return irr_IGUIImage_isAlphaChannelUsed(ptr);
    }

    void setSourceRect(recti sourceRect) {
        irr_IGUIImage_setSourceRect(ptr, irr_recti(sourceRect.x, sourceRect.y, sourceRect.x1, sourceRect.y1));
    }

    recti getSourceRect() {
        auto temp = irr_IGUIImage_getSourceRect(ptr);
        return recti(temp.x, temp.y, temp.x1, temp.y1);
    }

    void setDrawBounds(rectf drawBoundUVs) {
        auto temp = irr_rectf(drawBoundUVs.x, drawBoundUVs.y, drawBoundUVs.x1, drawBoundUVs.y1);
        irr_IGUIImage_setDrawBounds(ptr, temp);
    }

    rectf getDrawBounds() {
        auto temp = irr_IGUIImage_getDrawBounds(ptr);
        return rectf(temp.x, temp.y, temp.x1, temp.y1);
    }

	@property void* c_ptr() {
		return ptr;
	}

	@property void c_ptr(void* ptr) {
		this.ptr = cast(typeof(this.ptr))(ptr);
	}
private:
	irr_IGUIImage* ptr;
}

unittest {
	import dirrlicht.compileconfig;
	mixin(TestPrerequisite);
}

extern (C):

struct irr_IGUIImage;

void irr_IGUIImage_setImage(irr_IGUIImage* img, irr_ITexture* tex);
irr_ITexture* irr_IGUIImage_getImage(irr_IGUIImage* img);
void irr_IGUIImage_setColor(irr_IGUIImage* img, irr_SColor col);
void irr_IGUIImage_setScaleImage(irr_IGUIImage* img, bool scale);
void irr_IGUIImage_setUseAlphaChannel(irr_IGUIImage* img, bool use);
irr_SColor irr_IGUIImage_getColor(irr_IGUIImage* img);
bool irr_IGUIImage_isImageScaled(irr_IGUIImage* img);
bool irr_IGUIImage_isAlphaChannelUsed(irr_IGUIImage* img);
void irr_IGUIImage_setSourceRect(irr_IGUIImage* img, irr_recti sourceRect);
irr_recti irr_IGUIImage_getSourceRect(irr_IGUIImage* img);
void irr_IGUIImage_setDrawBounds(irr_IGUIImage* img, irr_rectf drawBoundUVs = irr_rectf(0, 0, 1, 1));
irr_rectf irr_IGUIImage_getDrawBounds(irr_IGUIImage* img);
