/*!
 * jquery-captcha v1.0 (https://github.com/honguangli/jquery-captcha)
 * Copyright honguangli
 * Licensed under the MIT license
 */
;
let Captcha;
(function($) {
  'use strict';
  const resourceUpper = ['A','B','C','E','F','G','H','J','K','L','M','N','P','Q','R','S','T','W','X','Y','Z'];
  const resourceLower = ['a','b','c','e','f','g','h','j','k','l','m','n','p','q','r','s','t','w','x','y','z'];
  const resourceNumber = ['0','1','2','3','4','5','6','7','8','9'];

  Captcha = function(element, options) {
    const self = this;
    const defaults = {
      length: 4,                     // ж ЎйЄЊз Ѓй•їеє¦
      width: 100,                    // canvasе®Ѕеє¦
      height: 40,                    // canvasй«еє¦
      font: 'bold 23px Arial',     // ж–‡жњ¬е­—дЅ“ж ·ејЏ
      resourceType: 'aA0',           // иµ„жєђз±»ећ‹пјљa-е°Џе†™е­—жЇЌгЂЃA-е¤§е†™е­—жЇЌгЂЃ0-ж•°е­—пјЊеЏЇд»»ж„Џз»„еђ€
      resourceExtra: [],             // йўќе¤–иµ„жєђ
      clickRefresh: true,            // з‚№е‡»е€·ж–°
      autoRefresh: true,             // и°ѓз”Ёж ЎйЄЊжЋҐеЏЈеђЋжЇеђ¦и‡ЄеЉЁе€·ж–°пј€ж ЎйЄЊж€ђеЉџдёЌдјље€·ж–°пј‰
      caseSensitive: false,          // е¤§е°Џе†™жЇеђ¦ж•Џж„џ
    };

    self.element = element;

    self.options = $.extend(true, defaults, options);

    // еђ€е№¶иµ„жєђ
    let resource = [];
    if (self.options.resourceType.length > 0) {
      if (self.options.resourceType.indexOf('A') !== -1) {
        resource = resource.concat(resourceUpper);
      }
      if (self.options.resourceType.indexOf('a') !== -1) {
        resource = resource.concat(resourceLower);
      }
      if (self.options.resourceType.indexOf('0') !== -1) {
        resource = resource.concat(resourceNumber);
      }
    }
    if (self.options.resourceExtra.length > 0) {
      resource = resource.concat(self.options.resourceExtra);
    }
    // й…ЌзЅ®иµ„жєђдёєз©є
    if (resource.length === 0) {
      resource = resourceUpper.concat(resourceLower).concat(resourceNumber)
    }
    self.resource = resource;

    if (self.options.clickRefresh) {
      self.element.on('click', function () {
          self.refresh();
      });
    }
    self.refresh();
  };
  // е€·ж–°
  Captcha.prototype.refresh = function() {
    const self = this;
      const canvas = document.getElementById('canvas');//$('.canvas');//self.element[0];                       // иЋ·еЏ–canvasеЇ№и±Ў
      if (canvas) {
          canvas.width = self.options.width;        // for pixels
          canvas.height = self.options.height;
          const context = canvas.getContext("2d");              // иЋ·еЏ–canvasзЋЇеўѓ
          context.font = self.options.font;

          const codes = self.randomCode();

          const spaceWidth = canvas.width - context.measureText(codes.join('')).width - 40;
          const wordSpace = Math.floor(spaceWidth / codes.length);

          let left = 10;
          for (let i = 0; i < codes.length; i++) {
              const deg = Math.random() * 30 * Math.PI / 180;     // дє§з”џ0~30д№‹й—ґзљ„йљЏжњєеј§еє¦
              const x = left;                                     // ж–‡жњ¬зљ„xеќђж ‡
              const y = canvas.height / 2 + Math.random() * 10;     // ж–‡жњ¬зљ„yеќђж ‡

              context.translate(x, y);
              context.rotate(deg);

              context.fillStyle = self.randomColor();
              context.fillText(codes[i], 0, 0);

              context.rotate(-deg);
              context.translate(-x, -y);

              left += context.measureText(codes[i]).width + wordSpace + Math.floor(Math.random() * 5);
          }

          self.code = codes;
          console.log(codes);

          const strokeLength = codes.length * Math.round(Math.random() + 1) + 3;
          for (let i = 0; i < strokeLength; i++) {
              context.strokeStyle = self.randomColor(true);
              context.beginPath();
              // жѕз¤єзєїжќЎ
              context.moveTo(Math.random() * self.options.width, Math.random() * self.options.height);
              context.lineTo(Math.random() * self.options.width, Math.random() * self.options.height);
              // жѕз¤єе°Џз‚№
              const x = Math.random() * self.options.width;
              const y = Math.random() * self.options.height;
              context.moveTo(x, y);
              context.lineTo(x + 1, y + 1);
              context.stroke();
          }
      }
  };
  // иЋ·еЏ–еЅ“е‰ЌйЄЊиЇЃз Ѓ
  Captcha.prototype.getCode = function() {
    return this.code.join('');
  };
  // ж ЎйЄЊ
  Captcha.prototype.valid = function(code) {
    const self = this;
    let ans = false;
    if (!self.options.caseSensitive) {
      ans = code.toLowerCase() === self.getCode().toLowerCase();
    } else {
      ans = code === self.getCode();
    }
    if (!ans && self.options.autoRefresh) {
      self.refresh();
    }
    return ans;
  };
  // иЋ·еЏ–йљЏжњєж ЎйЄЊз Ѓ
  Captcha.prototype.randomCode = function() {
    const self = this;
    const codes = [];
    const resourceLength = self.resource.length;
    for (let i = 0; i < self.options.length; i++) {
      const txt = self.resource[Math.floor(Math.random() * resourceLength)]; // еѕ—е€°йљЏжњєзљ„дёЂдёЄиµ„жєђз Ѓ
      codes.push(txt);
    }
    return codes;
  };
  // иЋ·еЏ–йљЏжњєзљ„йўњи‰ІеЂј
  Captcha.prototype.randomColor = function(alpha) {
    const r = Math.round(Math.random() * 255);
    const g = Math.round(Math.random() * 255);
    const b = Math.round(Math.random() * 255);
    if (!alpha) {
      return 'rgb(' + r + ',' + g + ',' + b + ')';
    }
    const a = Math.random();
    return 'rgb(' + r + ',' + g + ',' + b + ',' + a + ')';
  };
})($);
