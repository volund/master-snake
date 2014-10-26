//
//  SplashScreenViewController.m
//  snake-2
//
//  Created by Amos Joshua on 27/07/14.
//  Copyright (c) 2014 Amos Joshua. All rights reserved.
//

#import "SplashScreenViewController.h"

@interface SplashScreenViewController ()

@end

@implementation SplashScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSUserDefaults standardUserDefaults] synchronize];
    int score = [[NSUserDefaults standardUserDefaults] integerForKey:@"com.snake.highscore"];
    NSString *score_str = [NSString stringWithFormat:@"Best score: %d", score];
    self.scoreLabel.text = score_str;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)viewTapped:(id)sender {
    [self performSegueWithIdentifier:@"show-game" sender:self];
}


- (BOOL)shouldAutorotate{
    return YES;
}


-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

@end
