var game = new Phaser.Game(800, 600, Phaser.CANVAS, 'phaser-game', { preload: preload, create: create, update: update, render: render });

function preload() {

    game.load.tilemap('mario', '/assets/tilemaps/maps/super_mario.json', null, Phaser.Tilemap.TILED_JSON);
    game.load.image('tiles', '/assets/tilemaps/tiles/super_mario.png');
    game.load.image('player', '/assets/sprites/phaser-dude.png');


    //  37x45 is the size of each frame
    //  There are 18 frames in the PNG - you can leave this value blank if the frames fill up the entire PNG, but in this case there are some
    //  blank frames at the end, so we tell the loader how many to load
    game.load.spritesheet('mummy', '/assets/sprites/metalslug_mummy37x45.png', 37, 45, 18);

    //game.load.tilemap('level1', 'assets/games/starstruck/level1.json', null, Phaser.Tilemap.TILED_JSON);
    game.load.image('tiles-1', '/assets/games/starstruck/tiles-1.png');
    game.load.spritesheet('dude', '/assets/games/starstruck/dude.png', 32, 48);
    game.load.spritesheet('droid', '/assets/games/starstruck/droid.png', 32, 32);
    game.load.image('starSmall', '/assets/games/starstruck/star.png');
    game.load.image('starBig', '/assets/games/starstruck/star2.png');
    game.load.image('background', '/assets/games/starstruck/background2.png');

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

var mummy;
function create() {

    game.physics.startSystem(Phaser.Physics.ARCADE);

    game.stage.backgroundColor = '#000000';

    bg = game.add.tileSprite(0, 0, 800, 600, 'background');
    bg.fixedToCamera = true;

    //map = game.add.tilemap('level1');
    map = game.add.tilemap('mario');

    //map.addTilesetImage('tiles-1');
    map.addTilesetImage('SuperMarioBros-World1-1', 'tiles');

    map.setCollisionByExclusion([ 13, 14, 15, 16, 46, 47, 48, 49, 50, 51 ]);

    //layer = map.createLayer('Tile Layer 1');
    layer = map.createLayer('World1');

    //  Un-comment this on to see the collision tiles
    // layer.debug = true;

    layer.resizeWorld();

    layer.wrap = true;

    game.physics.arcade.gravity.y = 250;

    player = game.add.sprite(32, 32, 'dude');
    game.physics.enable(player, Phaser.Physics.ARCADE);

    player.body.bounce.y = 0.2;
    player.body.collideWorldBounds = true;
    player.body.setSize(20, 32, 5, 16);

    player.animations.add('left', [0, 1, 2, 3], 10, true);
    player.animations.add('turn', [4], 20, true);
    player.animations.add('right', [5, 6, 7, 8], 10, true);

    game.camera.follow(player);

    cursors = game.input.keyboard.createCursorKeys();
    jumpButton = game.input.keyboard.addKey(Phaser.Keyboard.SPACEBAR);

    releaseMummy();
}

function releaseMummy() {

    mummy = game.add.sprite(0, 0, 'mummy');
    mummy.name = "mummy"
    mummy.scale.setTo(2, 2);

    //  If you prefer to work in degrees rather than radians then you can use Phaser.Sprite.angle
    //  otherwise use Phaser.Sprite.rotation
    mummy.angle = 0

    mummy.animations.add('walk');
    mummy.animations.play('walk', 20, true);

    //game.add.tween(mummy).to({ x: game.width + (1600 + mummy.x) }, 20000, Phaser.Easing.Linear.None, true);

    game.physics.enable(mummy, Phaser.Physics.ARCADE);

    mummy.body.collideWorldBounds = true;
    mummy.body.setSize(20, 32, 5, 16);

}

function collisionHandler(obj1, obj2) {
    if (mummy.exists) {
        mummy.exists = false
    }
    //releaseMummy()
    //game.stage.backgroundColor = '#992d2d';

}

function update() {

    game.physics.arcade.collide(player, mummy, collisionHandler, null, this);

    game.physics.arcade.collide(player, layer);
    game.physics.arcade.collide(mummy, layer);
    mummy.body.velocity.x = 10;

    player.body.velocity.x = 0;

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
        player.body.velocity.y = -250;
        jumpTimer = game.time.now + 750;
    }

}

function render() {

    // game.debug.text(game.time.physicsElapsed, 32, 32);
    // game.debug.body(player);
    // game.debug.bodyInfo(player, 16, 24);

}
