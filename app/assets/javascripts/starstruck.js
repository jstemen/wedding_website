function loadGame() {
    var length = $('#phaser-game').length;
    var stageSize = {width:$(window).width(), height:432}

    if (length > 0) {
        game = new Phaser.Game(stageSize.width, stageSize.height , Phaser.CANVAS, 'phaser-game', {
            preload: preload,
            create: create,
            update: update,
            render: render
        });

        function preload() {

            game.load.tilemap('mario', '/assets/tilemaps/jared/super_mario.json', null, Phaser.Tilemap.TILED_JSON);
            game.load.image('tiles', '/assets/tilemaps/jared/super_mario.png');
            game.load.image('player', '/assets/sprites/phaser-dude.png');


            //  37x45 is the size of each frame
            //  There are 18 frames in the PNG - you can leave this value blank if the frames fill up the entire PNG, but in this case there are some
            //  blank frames at the end, so we tell the loader how many to load
            game.load.spritesheet('mummy', '/assets/sprites/metalslug_mummy37x45.png', 37, 45, 18);

            game.load.image('logo', '/assets/ours/instructions-400.png');

            game.load.spritesheet('dude', '/assets/palak.png', 32, 48);

            game.load.audio('jump', '/assets/sounds/smb_jump-small.ogg');
            game.load.audio('gameover', '/assets/sounds/smb_gameover.ogg');
            game.load.audio('mariodie', '/assets/sounds/smb_mariodie.ogg');
            game.load.audio('stomp', '/assets/sounds/smb_stomp.ogg');
            game.load.audio('music', '/assets/sounds/JooteDoPaiseLoHumAapkeHainKounsamwep.ogg');

        }

        var map;
        var tileset;
        var layer;
        var player;
        var facing = 'left';
        var jumpTimer = 0;
        var cursors;
        var jumpButton;
        var bg;
        var text
        var music

        var logo;


        var jump;
        var gameOverSound;
        var marioDiedSound;
        var stompSound;

        function create() {

            game.physics.startSystem(Phaser.Physics.ARCADE);

            game.stage.backgroundColor = '#000000';

            map = game.add.tilemap('mario');

            map.addTilesetImage('SuperMarioBros-World1-1', 'tiles');

            map.setCollision([14, 15, 16, 21, 22, 27, 28, 40]);
            music = new Phaser.Sound(game, 'music');
            music.play();

            layer = map.createLayer('World1');

            jump = new Phaser.Sound(game, 'jump');
            gameOverSound = new Phaser.Sound(game, 'gameover');
            marioDiedSound = new Phaser.Sound(game, 'mariodie');
            stompSound = new Phaser.Sound(game, 'stomp');


            layer.resizeWorld();

            layer.wrap = false;

            game.physics.arcade.gravity.y = 250;

            player = game.add.sprite(32, 32, 'dude');
            game.physics.enable(player, Phaser.Physics.ARCADE);

            player.body.bounce.y = 0;
            player.body.collideWorldBounds = true;
            player.body.setSize(20, 32, 5, 16);
            player.anchor.setTo(.5, 0);
            player.animations.add('left', [0, 1, 2, 3], 10, true);
            player.animations.add('turn', [4], 20, true);
            player.animations.add('right', [5, 6, 7, 8], 10, true);
            player.health = 100
            player.inputEnabled = true
            player.events.onKilled.add(function () {
                died()
            }, this);

            game.camera.follow(player);

            cursors = game.input.keyboard.createCursorKeys();
            jumpButton = game.input.keyboard.addKey(Phaser.Keyboard.SPACEBAR);

            logo = game.add.sprite(game.width / 4, 10, 'logo');

            //game.input.keyboard.onDown(removeLogo, this);

            setInterval(function () {
                var x = game.camera.x + game.camera.width;
                var enemy = new EnemyModule.Enemy(x, 0)
            }, 4000);

        }

        function printMsg(msg) {
            var style = {font: "100px Arial", fill: "white", align: "center"};
            var t = game.add.text($(window).width() / 2, 0, msg, style);
            t.fixedToCamera = true
        }

        function died() {
            printMsg("YOU DIED!");
            marioDiedSound.play();
            setTimeout(function () {
                location.reload();
            }, 4000)

        }

        function removeLogo() {
            game.input.onDown.remove(removeLogo, this);
            logo.kill();
        }

        var PlayerModule = function (game) {
            function Player() {

            }

        }()


        var EnemyModule = function (game) {
            var enemies = [];

            function Enemy(x, y) {
                //Here's where we create our player sprite.
                //Phaser.Sprite.call(game, x, y, 'mummy', null);
                Phaser.Sprite.call(this, game, x, y, 'mummy', 1)
                this.name = "mummy"
                var mummy = this
                this.scale.setTo(2, 2)
                this.angle = 0

                this.animations.add('walk');
                this.animations.play('walk', 20, true);
                this.anchor.setTo(.5, .5); //so it flips around its middle
                this.speed = Math.random()
                //game.add.tween(this).to({ x: game.width + (1600 + this.x) }, 20000, Phaser.Easing.Linear.None, true);

                game.physics.enable(this, Phaser.Physics.ARCADE);

                this.body.collideWorldBounds = true;
                this.body.setSize(20, 32, 5, 16);
                this.walk = function (speed) {
                    if (speed > 0) {
                        this.scale.x = 1; //flipped
                    } else {
                        this.scale.x = -1; //flipped
                    }
                    this.body.velocity.x = speed * this.speed;
                }
                this.walk(-50)

                this.myKill = function () {
                    mummy.kill();
                    var start = $.inArray(this, enemies);
                    enemies.splice(start, 1);
                    mummy.destroy();
                }

                game.add.existing(this)
                enemies.push(this);
            }

            //We give our player a type of Phaser.Sprite and assign it's constructor method.
            Enemy.prototype = Object.create(Phaser.Sprite.prototype);
            Enemy.prototype.constructor = Enemy;
            Enemy.prototype.update = function () {
                var mummy = this
                if (mummy.y === game.height && mummy.alive) {
                      mummy.myKill();
                }
            }
            return {Enemy: Enemy, enemies: enemies}
        }(game)


        function collisionHandler(obj1, enemy) {
            if (obj1.body.touching.down) {
                stompSound.play();
                enemy.kill()
                player.body.velocity.y = -250;
            } else if (enemy.exists) {
                player.damage(5)
            }
        }

        function enemyColHandler(enemy, obj1) {
            if (enemy.body.blocked.right) {
                enemy.walk(-50);
            }
            if (enemy.body.blocked.left) {
                enemy.walk(50);
            }
            var foo = 1;
        }

        function update() {

            //console.log(player.x)
            $.each(EnemyModule.enemies, function (index, enemy) {
                game.physics.arcade.collide(player, enemy, collisionHandler, null, this);
                game.physics.arcade.collide(enemy, layer, enemyColHandler);
            });

            game.physics.arcade.collide(player, layer);

            player.body.velocity.x = 0;
            if (player.x > 3183) {
                printMsg("The save the date is..")
            }

            if (player.y > game.height - 20 && player.alive) {
                player.kill();
            }


            if (cursors.left.isDown) {
                player.body.velocity.x = -150;

                if (facing != 'left') {
                    player.animations.play('left');
                    facing = 'left';
                }
            }
            else if (cursors.right.isDown) {
                player.body.velocity.x = 150;

                if (facing != 'right') {
                    player.animations.play('right');
                    facing = 'right';
                }
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

            if (jumpButton.isDown && player.body.onFloor() && game.time.now > jumpTimer) {
                jump.play()
                player.body.velocity.y = -250;
                jumpTimer = game.time.now + 750;
            }

        }

        function render() {

            // game.debug.text(game.time.physicsElapsed, 32, 32);
            // game.debug.body(player);
            // game.debug.bodyInfo(player, 16, 24);

        }
    }
}
