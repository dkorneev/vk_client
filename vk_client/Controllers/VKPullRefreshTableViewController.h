//
// Created by dkorneev on 12/1/12.
//



#import <Foundation/Foundation.h>
#import "EGORefreshTableHeaderView.h"


@interface VKPullRefreshTableViewController : UITableViewController <EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource> {

    EGORefreshTableHeaderView *_refreshHeaderView;

    //  Reloading var should really be your tableviews datasource
    //  Putting it here for demo purposes
    BOOL _reloading;
}

@property(nonatomic) BOOL reloading;
@property(nonatomic, strong) EGORefreshTableHeaderView *refreshHeaderView;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end