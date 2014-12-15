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

            game.load.tilemap('mario', '/assets/tilemaps/jared/super_mario.json', null, Phaser.Tilemap.TILED_JSON);
            game.load.image('tiles', '/assets/tilemaps/jared/super_mario.png');
            game.load.image('player', '/assets/sprites/phaser-dude.png');

            //  37x45 is the size of each frame
            //  There are 18 frames in the PNG - you can leave this value blank if the frames fill up the entire PNG, but in this case there are some
            //  blank frames at the end, so we tell the loader how many to load

            game.load.spritesheet('mummy', '/assets/jarebear.png', 32, 48);
            game.load.image('instructions', '/assets/instructions-text.png');

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

        function create() {

            game.physics.startSystem(Phaser.Physics.ARCADE);

            game.stage.backgroundColor = '#000000';

            map = game.add.tilemap('mario');

            map.addTilesetImage('SuperMarioBros-World1-1', 'tiles');

            map.setCollision([14, 15, 16, 21, 22, 27, 28, 40]);
            music = new Phaser.Sound(game, 'music');
            music.play();
            layer = map.createLayer('World1'); //Sprites must be added below this line

            //Add though bubble style instructions
            const scale = .5
            instructions= game.add.sprite(20, 10, 'instructions');
            instructions.width = instructions.width * scale
            instructions.height = instructions.height * scale

            //Add shoes
            shoes = game.add.sprite(32,32, 'shoes');
            game.physics.enable(shoes, Phaser.Physics.ARCADE);
            shoes.body.setSize(20, 32, 5, 16);
            shoes.scale.setTo(.5,.5)

            //load sounds
            jumpSound = new Phaser.Sound(game, 'jump');
            gameOverSound = new Phaser.Sound(game, 'gameover');
            marioDiedSound = new Phaser.Sound(game, 'mariodie');
            stompSound = new Phaser.Sound(game, 'stomp');


            layer.resizeWorld();
            layer.wrap = false;
            game.physics.arcade.gravity.y = 250;


            PlayerModule.player = new PlayerModule.Player(32, 32);

            cursors = game.input.keyboard.createCursorKeys();
            jumpButton = game.input.keyboard.addKey(Phaser.Keyboard.SPACEBAR);
            f1Button = game.input.keyboard.addKey(Phaser.Keyboard.F1);

            setInterval(function () {
                var x = game.camera.x + game.camera.width;
                var enemy = new EnemyModule.Enemy(x, 0)
            }, 20000);
        }

        var PlayerModule = function (game) {
            this.player;

            function Player(x, y) {
                this.hasShoes=false;
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

            Player.prototype = Object.create(Phaser.Sprite.prototype);
            Player.prototype.constructor = Player;
            Player.prototype.enableGodMode = function(){
                Player.prototype.origKill = Player.prototype.kill
                Player.prototype.kill = function(){}
                this.horizSpeed = 1500;
                this.jumpSpeed = -500;
            }
            Player.prototype.update = function () {
                var player = this
                game.physics.arcade.collide(player, layer);
                if (player.y === game.height && player.alive) {
                    player.kill();
                }
                player.body.velocity.x = 0;
                if (player.x > 3183 && player.hasShoes) {
                    printMsg("The save the date is September 26th 2015!".toUpperCase())
                }
                if(f1Button.isDown){
                    this.enableGodMode();
                }
                if (player.y > game.height - 20 && player.alive) {
                    player.kill();
                }
                if (cursors.left.isDown) {
                    player.body.velocity.x = player.horizSpeed * -1;

                    if (facing != 'left') {
                        player.animations.play('left');
                        facing = 'left';
                    }
                }
                else if (cursors.right.isDown) {
                    player.body.velocity.x = player.horizSpeed;

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
                if (cursors.down.isDown) {
                    player.body.velocity.y = player.jumpSpeed* -.75;
                }
                if ((cursors.up.isDown || jumpButton.isDown) && player.body.onFloor() && game.time.now > jumpTimer) {
                    jumpSound.play()
                    player.body.velocity.y = player.jumpSpeed;
                    jumpTimer = game.time.now + 750;
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
                this.anchor.setTo(.5,.5); //so it flips around its middle
                this.speed = Math.random()
                this.scale.setTo(2, 2)

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

            //We give our player a type of Phaser.Sprite and assign it's constructor method.
            Enemy.prototype = Object.create(Phaser.Sprite.prototype);
            Enemy.prototype.constructor = Enemy;
            Enemy.prototype.update = function () {
                var mummy = this
                if (mummy.y === game.height && mummy.alive) {
                    mummy.myKill();
                }
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
            return {Enemy: Enemy, enemies: enemies}
        }(game)

        var printMsg = function(){
            var lastMsg;
            function printMsg(msg) {
                if (lastMsg != null){
                    lastMsg.destroy();
                }
                var style = {font: "50px Arial", fill: "white", align: "center"};
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

            game.physics.arcade.collide(shoes, layer);
            game.physics.arcade.collide(PlayerModule.player, shoes, function(player, shoes){
                shoes.destroy();
                player.hasShoes=true
            });
        }

        function render() {


        }
    }
}
