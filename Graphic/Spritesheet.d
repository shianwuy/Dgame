/*
 *******************************************************************************************
 * Dgame (a D game framework) - Copyright (c) Randy Schütt
 * 
 * This software is provided 'as-is', without any express or implied warranty.
 * In no event will the authors be held liable for any damages arising from
 * the use of this software.
 * 
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 * 
 * 1. The origin of this software must not be misrepresented; you must not claim
 *    that you wrote the original software. If you use this software in a product,
 *    an acknowledgment in the product documentation would be appreciated but is
 *    not required.
 * 
 * 2. Altered source versions must be plainly marked as such, and must not be
 *    misrepresented as being the original software.
 * 
 * 3. This notice may not be removed or altered from any source distribution.
 *******************************************************************************************
 */
module Dgame.Graphic.Spritesheet;

private:

import Dgame.Graphic.Texture;
import Dgame.Graphic.Sprite;

import Dgame.Math.Rect;

import Dgame.System.StopWatch;

public:

/**
 * SpriteSheet extends Sprite and act like a Texture Atlas.
 *
 * Author: Randy Schuett (rswhite4@googlemail.com)
 */
class Spritesheet : Sprite {
protected:
    uint _lastUpdate = 0;
    uint _execCount = 0;

public:
    /**
     * The timeout between the slides
     */
    uint timeout = 0;
    /**
     * The amount of executions of the <b>whole</b> slide
     * -1 or less means infinite sliding
     */
    int numOfExecutions = -1;

final:
    /**
     * CTor
     */
    @nogc
    this(ref Texture tex) pure nothrow {
        super(tex);
    }

    /**
     * CTor
     */
    @nogc
    this()(ref Texture tex, auto ref Rect texRect) pure nothrow {
        this(tex);

        super.setTextureRect(texRect);
    }

    /**
     * Returns the last update which means the last happened slide
     */
    @property
    @nogc
    uint lastUpdate() const pure nothrow {
        return _lastUpdate;
    }

    /**
     * Returns the current execution count
     */
    @property
    @nogc
    uint executionCounter() const pure nothrow {
        return _execCount;
    }

    /**
     * Manual moving of the Texture Rect
     */
    @nogc
    void moveTextureRect(int x, int y) pure nothrow {
        _texRect.move(x, y);
        _updateVertices();
    }

    /**
     * Slide / move the current view of the Texture,
     * so that the next view of the Texture will be drawn.
     * This happens by moving the Texture Rect.
     */
    @nogc
    void slideTextureRect() nothrow {
        if (this.numOfExecutions >= 0 && _execCount >= this.numOfExecutions)
            return;

        if ((_lastUpdate + this.timeout) > StopWatch.getTicks())
            return;

        _lastUpdate = StopWatch.getTicks();

        if ((_texRect.x + _texRect.width) < _texture.width)
            _texRect.x += _texRect.width;
        else {
            _texRect.x = 0;

            if ((_texRect.y + _texRect.height) < _texture.height)
                _texRect.y += _texRect.height;
            else {
                _texRect.y = 0;
                _execCount++;
            }
        }

        _updateVertices();
    }
}