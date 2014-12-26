function loadGame() {
    var length = $('#phaser-game').length;
    var stageSize = {width: $(window).width(), height: 432}

    if (length > 0) {

        game = new Phaser.Game(stageSize.width, stageSize.height, Phaser.CANVAS, 'phaser-game', {
            preload: preload,
            create: create,
            update: update,
            render: render
        });


        function preload() {

            game.load.tilemap('mario', '/assets/tilemaps/jared/super_mario3.json', null, Phaser.Tilemap.TILED_JSON);
            game.load.image('tiles', '/assets/tilemaps/jared/super_mario.png');
            game.load.image('player', '/assets/sprites/phaser-dude.png');
            game.load.image('blue', '/assets/particles/blue.png');
            game.load.image('red', '/assets/particles/red.png');
            game.load.image('yellow', '/assets/particles/yellow.png');
            game.load.image('green', '/assets/particles/green.png');
            game.load.image('mfire', '/assets/mediumFireworks.png');
            game.load.image('sfire', '/assets/smallFireworks.png');
            game.load.image('lfire', '/assets/largeFireworks.png');
            game.load.image('carrot', '/assets/sprites/carrot.png');
            game.load.image('star', '/assets/misc/star_particle.png');
            game.load.image('diamond', '/assets/sprites/diamond.png')
            //  37x45 is the size of each frame
            //  There are 18 frames in the PNG - you can leave this value blank if the frames fill up the entire PNG, but in this case there are some
            //  blank frames at the end, so we tell the loader how many to load

            game.load.spritesheet('mummy', '/assets/jarebear.png', 32, 48);
            game.load.image('instructions', '/assets/instructions-text.png');
            game.load.image('temple', '/assets/temple_final.png');

            game.load.spritesheet('dude', '/assets/palakFull.png', 32, 48);
            game.load.spritesheet('shoes', '/assets/shoes.png', 46, 39);

            game.load.audio('jump', '/assets/sounds/smb_jump-small.ogg');
            game.load.audio('gameover', '/assets/sounds/smb_gameover.ogg');
            game.load.audio('mariodie', '/assets/sounds/smb_mariodie.ogg');
            game.load.audio('stomp', '/assets/sounds/smb_stomp.ogg');
            game.load.audio('music', '/assets/sounds/JooteDoPaiseLoHumAapkeHainKounsamwep.ogg');

        }

        var map;
        var tileset;
        var layer;
        var facing = 'left';
        var jumpTimer = 0;
        var cursors;
        var jumpButton;
        var f1Button;
        var bg;
        var text
        var music

        var instructions;

        var jumpSound;
        var gameOverSound;
        var marioDiedSound;
        var stompSound;
        var shoes;
        const gravityLevel = 250

        function MySpriteBase() {
            this.myKill = function () {
                this.kill();
            }
            this.myUpdate = function () {
            }
        }

        MySpriteBase.prototype = Object.create(Phaser.Sprite.prototype);
        MySpriteBase.constructor = MySpriteBase
        MySpriteBase.prototype.update = function () {
            if (this.y >= game.height && this.alive) {
                this.myKill();
            }
            this.myUpdate.apply(this)
        }
        var mySpriteBase = new MySpriteBase();

        function create() {

            game.physics.startSystem(Phaser.Physics.ARCADE);

            game.stage.backgroundColor = '#000000';

            map = game.add.tilemap('mario');

            map.addTilesetImage('SuperMarioBros-World1-1', 'tiles');

            map.setCollision([14, 15, 16, 21, 22, 27, 28, 40]);
            music = game.add.audio('music');
            music.play();
            layer = map.createLayer('World1'); //Sprites must be added below this line

            //Add though bubble style instructions
            const scale = .5
            instructions = game.add.sprite(20, 10, 'instructions');
            var temple = game.add.sprite(3100, 330, 'temple');
            temple.width = temple.width * .5
            temple.height = temple.height * .5

            instructions.width = instructions.width * scale
            instructions.height = instructions.height * scale


            //load sounds
            jumpSound = new Phaser.Sound(game, 'jump');
            gameOverSound = new Phaser.Sound(game, 'gameover');
            marioDiedSound = new Phaser.Sound(game, 'mariodie');
            stompSound = new Phaser.Sound(game, 'stomp');


            layer.resizeWorld();
            layer.wrap = false;
            game.physics.arcade.gravity.y = gravityLevel;


            PlayerModule.player = new PlayerModule.Player(32, 32);

            cursors = game.input.keyboard.createCursorKeys();
            jumpButton = game.input.keyboard.addKey(Phaser.Keyboard.SPACEBAR);
            f1Button = game.input.keyboard.addKey(Phaser.Keyboard.F1);
            EnemyModule.startEnemyCreation();

            game.stage.backgroundColor = '#000000';

        }

        var startFireworks = function () {
            var createLoc = function (x, y) {
                var emitter = emitter || game.add.emitter(x, y);
                //  Here we're passing an array of image keys. It will pick one at random when emitting a new particle.
                emitter.makeParticles(['sfire', 'mfire', 'lfire']);
                emitter.minParticleSpeed.setTo(0, 0);
                emitter.maxParticleSpeed.setTo(0, 0);
                emitter.setRotation(0, 0);
                emitter.setAlpha(.3, 0.8);
                emitter.setScale(1, 1);
                //Need to counteract gravity
                emitter.gravity = -1 * gravityLevel;
                emitter.start(false, 500, 1000 + 5000 * Math.random());
                setInterval(function () {
                    emitter.x = randX();
                    emitter.y = randY();
                }, 7000)
            }
            var randPos = function () {
                var number = Math.pow(Math.random(), 2);
                return number
            }
            var randX = function () {
                var number = game.world.width - 100 - randPos() * 300;
                return number
            }
            var randY = function () {
                var number = 200 - randPos() * 100;
                return number
            }
            for (var i = 0; i < 3; i++) {
                createLoc(randX(), randY())
            }
        }

        var ShoesModule = function (game) {
            var allShoes = []
            var Shoes = function (x, y) {
                //Add shoes
                Phaser.Sprite.call(this, game, x, y, 'shoes', 1)
                game.physics.enable(this, Phaser.Physics.ARCADE);
                this.body.collideWorldBounds = true;
                this.body.setSize(20, 32, 5, 16);
                this.scale.setTo(.5, .5)
                game.add.existing(this)
                allShoes.push(this)
            }

            Shoes.prototype.constructor = Shoes;
            Shoes.prototype = Object.create(mySpriteBase);
            Shoes.prototype.myUpdate = function () {
                game.physics.arcade.collide(this, layer);
            }
            return {Shoes: Shoes, allShoes: allShoes}
        }(game);

        var PlayerModule = function (game) {
            this.player;

            function Player(x, y) {
                this.hasShoes = false;
                this.horizSpeed = 150;
                this.jumpSpeed = -200;
                Phaser.Sprite.call(this, game, x, y, 'dude', 1)
                game.physics.enable(this, Phaser.Physics.ARCADE);
                this.body.bounce.y = 0;
                this.body.collideWorldBounds = true;
                this.body.setSize(20, 32, 5, 16);
                this.anchor.setTo(.5, 0);
                this.animations.add('left', [0, 1, 2, 3], 10, true);
                this.animations.add('turn', [4], 20, true);
                this.animations.add('right', [5, 6, 7, 8], 10, true);
                this.health = 100
                this.inputEnabled = true
                this.events.onKilled.add(function () {
                    died()
                }, this);

                game.add.existing(this)
                game.camera.follow(this);
                PlayerModule.player = this;
            }

            function died() {
                printMsg("YOU DIED!");
                marioDiedSound.play();
                setTimeout(function () {
                    location.reload();
                }, 4000)
            }

            Player.prototype = Object.create(mySpriteBase)
            Player.prototype.constructor = Player;
            Player.prototype.enableGodMode = function () {
                Player.prototype.origKill = Player.prototype.kill
                Player.prototype.kill = function () {
                }
                this.horizSpeed = 3000;
                this.jumpSpeed = -500;
            }
            Player.prototype.moveRight = function () {
                this.body.velocity.x = this.horizSpeed;

                if (facing != 'right') {
                    this.animations.play('right');
                    facing = 'right';
                }
            }

            Player.prototype.moveLeft = function () {
                this.body.velocity.x = this.horizSpeed * -1;

                if (facing != 'left') {
                    this.animations.play('left');
                    facing = 'left';
                }
            }

            Player.prototype.jump = function() {
                if (this.body.onFloor() && game.time.now > jumpTimer) {
                    jumpSound.play()
                    this.body.velocity.y = this.jumpSpeed;
                    jumpTimer = game.time.now + 750;
                }
            }

            Player.prototype.myUpdate = function () {
                var player = this
                //game.physics.arcade.collide(player, layer);
                game.physics.arcade.collide(player, layer, function (bod, tile) {
                    if (tile.index == 14 && bod.body.blocked.up == true && !tile.madeShoes) {
                        //Add shoes
                        var y = tile.worldY - tile.width * 2;
                        var x = tile.worldX;
                        new ShoesModule.Shoes(x, y);
                        tile.madeShoes = true
                    }
                });
                player.body.velocity.x = 0;
                var pointer1 = game.input.pointer1;
                var pointer2 = game.input.pointer2;
                if (pointer2.isDown && pointer1.isDown) {
                    this.jump();
                } else if (pointer1.isDown) {
                    var halfWidth = game.width / 2;
                    if(pointer1.x > halfWidth){
                        this.moveRight();
                    }else{
                        this.moveLeft();
                    }
                }
                if (player.x > 3183 && player.hasShoes) {
                    player.hasShoes = false
                    startFireworks()
                    EnemyModule.stopEnemyCreation()
                    $.each(EnemyModule.enemies, function (i, enemy) {
                        enemy.kill()
                    });
                    printMsg("Save the Date! September 26, 2015")
                }
                if (f1Button.isDown) {
                    this.enableGodMode();
                }
                if (player.y > game.height - 20 && player.alive) {
                    player.kill();
                }
                if (cursors.left.isDown) {
                    this.moveLeft(player);
                }
                else if (cursors.right.isDown) {
                    this.moveRight(player);
                }
                else {
                    if (facing != 'idle') {
                        player.animations.stop();

                        if (facing == 'left') {
                            player.frame = 0;
                        }
                        else {
                            player.frame = 5;
                        }

                        facing = 'idle';
                    }
                }
                if (cursors.down.isDown) {
                    player.body.velocity.y = player.jumpSpeed * -.75;
                }
                if (cursors.up.isDown || jumpButton.isDown) {
                    this.jump();
                }
            }
            return {Player: Player, died: died}
        }(game);

        var EnemyModule = function (game) {
            var enemies = [];

            function Enemy(x, y) {
                //Here's where we create our player sprite.
                //Phaser.Sprite.call(game, x, y, 'mummy', null);
                Phaser.Sprite.call(this, game, x, y, 'mummy', 1)
                this.name = "mummy"
                var mummy = this

                this.animations.add('left', [0, 1, 2, 3], 10, true);
                this.animations.add('turn', [4], 20, true);
                this.animations.add('right', [5, 6, 7, 8], 10, true);
                this.anchor.setTo(.5, .5); //so it flips around its middle
                this.speed = Math.random()
                this.scale.setTo(1.2, 1.2)

                game.physics.enable(this, Phaser.Physics.ARCADE);

                this.body.setSize(20, 32, 5, 16);
                this.body.collideWorldBounds = true;

                this.animations.play('right');
                this.checkWorldBounds = true;
                this.outOfBoundsKill = true
                this.events.onOutOfBounds.add(this.dropRef, this);

                this.walk(-50)
                game.add.existing(this)
                enemies.push(this);
            }

            var enemyTimer = 0;
            var onBlur = function () {
                clearInterval(enemyTimer);
                enemyTimer = 0;
            }
            var onFocus = function () {
                clearInterval(enemyTimer)
                enemyTimer = setEnemyCreationTime()
            }
            //Creates a set of timers that periodically create enemies when the browser tab is active
            var startEnemyCreation = function () {
                $(window).blur(onBlur);
                $(window).focus(onFocus);
                function setEnemyCreationTime() {
                    return setInterval(function () {
                        var x = game.camera.x + game.camera.width;
                        var enemy = new EnemyModule.Enemy(x, 0)
                    }, 10000);
                }

                enemyTimer = setEnemyCreationTime();
            }
            var stopEnemyCreation = function () {
                $(window).unbind("blur", onBlur);
                $(window).unbind("focus", onFocus);
                clearInterval(enemyTimer)
            }

            function setEnemyCreationTime() {
                return setInterval(function () {
                    var x = game.camera.x + game.camera.width;
                    var enemy = new EnemyModule.Enemy(x, 0)
                }, 10000);
            }

            //We give our player a type of Phaser.Sprite and assign it's constructor method.
            Enemy.prototype = Object.create(mySpriteBase)
            Enemy.prototype.constructor = Enemy;
            Enemy.prototype.myUpdate = function () {
                var mummy = this
                game.physics.arcade.collide(mummy, layer, enemyColHandler);
            }

            Enemy.prototype.walk = function (speed) {
                if (speed > 0) {
                    this.scale.x = 1; //flipped
                } else {
                    this.scale.x = -1; //flipped
                }
                this.body.velocity.x = speed * this.speed;
            }
            Enemy.prototype.dropRef = function () {
                var start = $.inArray(this, enemies);
                enemies.splice(start, 1);
            }
            Enemy.prototype.myKill = function () {
                this.dropRef()
                this.destroy();
            }
            function enemyColHandler(enemy, obj1) {
                if (enemy.body.blocked.right) {
                    enemy.walk(-50);
                }
                if (enemy.body.blocked.left) {
                    enemy.walk(50);
                }
            }

            return {
                Enemy: Enemy,
                enemies: enemies,
                startEnemyCreation: startEnemyCreation,
                stopEnemyCreation: stopEnemyCreation
            }
        }(game)

        var printMsg = function () {
            var lastMsg;

            function printMsg(msg) {
                if (lastMsg != null) {
                    lastMsg.destroy();
                }
                var style = {font: "50px Lucon", fill: "white", align: "center"};
                Phaser.Text
                var t = game.add.text(20, 20, msg, style);
                t.fixedToCamera = true
                lastMsg = t;
            }

            return printMsg;
        }();


        function enemyPlayerCollisionHandler(obj1, enemy) {
            if (obj1.body.touching.down) {
                stompSound.play();
                enemy.kill()
                PlayerModule.player.body.velocity.y = -250;
            } else if (enemy.exists) {
                PlayerModule.player.damage(5)
            }
        }


        function update() {

            $.each(EnemyModule.enemies, function (index, enemy) {
                game.physics.arcade.collide(PlayerModule.player, enemy, enemyPlayerCollisionHandler);
            });
            $.each(ShoesModule.allShoes, function (index, shoes) {
                game.physics.arcade.collide(PlayerModule.player, shoes, function (player, shoes) {
                    shoes.destroy();
                    player.hasShoes = true
                });
            })
        }

        function render() {


        }
    }
}
