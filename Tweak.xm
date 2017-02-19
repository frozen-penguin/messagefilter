@class _UISecureHostedWindow, CKMessagesNotificationViewController, CKNotificationReplyViewController, CKMessageEntryRichTextView, CKMessageEntryView, CKConversation, CNContact, CKTranscriptController, CKViewController, CKBalloonTextView, CKTranscriptDetailsResizableCell;


@interface _UIHostedWindow : UIWindow
@end

@interface _UISecureHostedWindow : _UIHostedWindow
+(BOOL)_isSecure;
@end

@interface CKMessagesNotificationViewController : UIViewController
@end

@interface NCInteractiveNotificationHostViewController : UIViewController
@end

@interface NCInteractiveNotificationViewController : UIViewController
@property (copy, nonatomic) NSDictionary *context;
@end

@interface CKInlineReplyViewController : NCInteractiveNotificationViewController
@property (retain, nonatomic) CKMessageEntryView *entryView;
- (UITextView *)viewForTyping;
- (void)setupConversation;
- (void)setupView;
- (void)interactiveNotificationDidAppear;
- (void)updateSendButton;
- (void)updateTyping;
- (void)sendMessage;
- (void)dismissWithContext:(id)arg1;
-(NSDictionary *)context;
-(void)sendAnyway;
-(void)messageEntryViewSendButtonHit:(CKMessageEntryView*)arg1;
@end

// ChatKit declarations
@interface CKConversation
-(NSString *)name;
@end

//iOS 10
@interface CKNotificationChatController : UIViewController
-(CKConversation *)conversation;
-(void)sendAnyway;
-(CKMessageEntryView *)entryView;
-(void)messageEntryViewSendButtonHit:(CKMessageEntryView*)arg1;
- (UIViewController *)collectionViewController;
-(CKMessagesNotificationViewController *)_delegate;
@end

@interface CKMessageEntryRichTextView
-(NSString *)text;
@end

@interface CKMessageEntryContentView : UIScrollView
@property (nonatomic, retain) CKMessageEntryRichTextView *textView;
@end

@interface CKMessageEntryView : UIImageView
@property (nonatomic, retain) CKMessageEntryContentView *contentView;
@end

@interface CKTranscriptController : UINavigationController
-(void)closeAlertView;
-(void)sendAnyway;
-(CKMessageEntryView *)entryView;
-(void)messageEntryViewSendButtonHit:(CKMessageEntryView*)arg1;
@end

@interface CKTranscriptCollectionViewController
-(CKConversation *)conversation;
-(void)closeAlertView;
@end

@interface CKChatController : UIViewController
-(CKConversation *)conversation;
-(void)closeAlertView;
-(void)sendAnyway;
-(CKMessageEntryView *)entryView;
-(void)messageEntryViewSendButtonHit:(CKMessageEntryView*)arg1;
@end

@interface CKDetailsController : UIViewController
@property (nonatomic, retain) CKTranscriptDetailsResizableCell *blacklistCell;
@property (nonatomic, retain) CKTranscriptDetailsResizableCell *whitelistCell;
-(CKTranscriptDetailsResizableCell *)locationSendCell;
-(CKConversation *)conversation;
@end

@interface  CKTranscriptManagementController : UIViewController
@property (nonatomic, retain) CKTranscriptDetailsResizableCell *blacklistCell;
@property (nonatomic, retain) CKTranscriptDetailsResizableCell *whitelistCell;
-(CKTranscriptDetailsResizableCell *)locationSendCell;
-(CKConversation *)conversation;
@end

@interface CKTranscriptDetailsResizableCell : UITableViewCell
-(UILabel *)textLabel;
@end

static NSString *MNTitle;
static NSArray *triggerWords;
static NSMutableArray *whitelistArray;
static NSMutableArray *blacklistArray;
static BOOL sendThat;
static NSMutableArray *whitelistPeople;

@interface blacklistController : UITableViewController
- (id)initWithName:(NSString *)name withData:(NSArray *)data;
-(void)editMode;
@end

@interface whitelistController : UITableViewController
- (id)initWithName:(NSString *)name withData:(NSArray *)data;
-(void)editMode;
@end

@interface blacklistController () {
    NSString *_name;
}
@property (nonatomic, strong) NSArray *data;
@end

@interface whitelistController () {
    NSString *_name;
}
@property (nonatomic, strong) NSArray *data;
@end

@implementation blacklistController

@synthesize data = _data;

- (id)initWithName:(NSString *)passedName withData:(NSArray *)data
{
    if(self = [super init]){
        _name = passedName;
       _data = data;

        UITableView *table = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        [self.view addSubview:table];
        self.tableView = table;
    }

    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
        UIBarButtonItem *toggleBtn = [[UIBarButtonItem alloc]
        	initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered
        	target:self action:@selector(editMode)];
			((UINavigationItem *)[super navigationItem]).rightBarButtonItem = toggleBtn;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
      self.title = @"Blacklisted Words";
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
if (section == 0)
   return 1;
else
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"blacklistCell"];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"blacklistCell"];
    }
switch (indexPath.section){
        case 0:
            cell.textLabel.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
            switch (indexPath.row) {
                  case 0:
                      cell.textLabel.text = @"Add new word";
                      break;
                  case 1:
                      cell.textLabel.text = @"";
                      break;
                  case 2:
                      cell.textLabel.text = @"";
                      break;
                  default:
                      break;
              }
            break;
       case 1:
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
          cell.textLabel.text = _data[indexPath.row];
          break;
     }
     return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"";
            break;
        case 1:
          return @"Blacklisted words";
            break;
        default:
            break;
    }
    return @"";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.section > 0)
        return YES;
    else
        return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
     NSMutableArray *newData = [_data mutableCopy];
    [newData removeObjectAtIndex:indexPath.row];
     _data = [newData copy];
     triggerWords = _data;
      NSMutableString *fullPath = [[NSMutableString alloc]init];
       [fullPath appendString:@"/var/mobile/Library/gotyourback/"];
       [fullPath appendString:_name];
       [fullPath appendString:@".plist"];
       [_data writeToFile:fullPath atomically:YES];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)editMode
{
  if (self.tableView.isEditing == NO)
  {
     [self.tableView setEditing: YES animated:YES];
     self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"Done", @"Done");
  }
  else
  {
     [self.tableView setEditing: NO animated:YES];
     self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"Edit", @"Edit");
  }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        UIAlertController *alertController = [UIAlertController
                            alertControllerWithTitle:@"Enter new word"
                                             message:@""
                                      preferredStyle:UIAlertControllerStyleAlert];

        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
         {
           textField.placeholder = NSLocalizedString(@"", @"");
         }];

         [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    UITextField *textField = alertController.textFields[0];
    NSString *newWord = textField.text;
        if (![newWord isEqualToString:@""])
    [self addWord:newWord];
    else
           [self.tableView reloadData];

}]];
    [self presentViewController:alertController animated:YES completion:nil];
      }
  //    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

-(void)addWord:(NSString *)word
{
      NSMutableString *fullPath = [[NSMutableString alloc]init];
       [fullPath appendString:@"/var/mobile/Library/gotyourback/"];
       [fullPath appendString:_name];
       [fullPath appendString:@".plist"];
       NSMutableArray *blacklistWords = [[NSMutableArray alloc] initWithContentsOfFile:fullPath];
       if (!blacklistWords)
          blacklistWords = [NSMutableArray new];
       [blacklistWords addObject:[word lowercaseString]];
       [blacklistWords writeToFile:fullPath atomically:YES];
         _data = [blacklistWords copy];
         triggerWords = _data;
       [self.tableView reloadData];
}
@end

@implementation whitelistController

@synthesize data = _data;

- (id)initWithName:(NSString *)passedName withData:(NSArray *)data
{
    if(self = [super init]){
        _name = passedName;
       _data = data;

        UITableView *table = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        [self.view addSubview:table];
        self.tableView = table;
    }

    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
        UIBarButtonItem *toggleBtn = [[UIBarButtonItem alloc]
        	initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered
        	target:self action:@selector(editMode)];
			((UINavigationItem *)[super navigationItem]).rightBarButtonItem = toggleBtn;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
      self.title = @"Whitelisted Words";
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
if (section == 0)
   return 1;
else
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"whitelistCell"];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"whitelistCell"];
    }
switch (indexPath.section){
        case 0:
            cell.textLabel.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
            switch (indexPath.row) {
                  case 0:
                      cell.textLabel.text = @"Add new word";
                      break;
                  case 1:
                      cell.textLabel.text = @"";
                      break;
                  case 2:
                      cell.textLabel.text = @"";
                      break;
                  default:
                      break;
              }
            break;
       case 1:
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
          cell.textLabel.text = _data[indexPath.row];
          break;
     }
     return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Words will trigger in every conversation except this one";
            break;
        case 1:
          return @"Whitelisted words";
            break;
        default:
            break;
    }
    return @"";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.section > 0)
        return YES;
    else
        return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
       NSMutableArray *newData = [_data mutableCopy];
       [newData removeObjectAtIndex:indexPath.row];
       _data = [newData copy];
       triggerWords = _data;
       NSString *fullPath = @"/var/mobile/Library/gotyourback/whitelist.plist";
       NSMutableArray *fullList = [[NSMutableArray alloc] initWithContentsOfFile:fullPath];
       int removalIndex = 0;
       for (NSString *lineString in fullList)
       {
          NSArray *tempArray = [lineString componentsSeparatedByString:@":"];
          if ([tempArray[0] isEqualToString:_name])
              removalIndex = [fullList indexOfObject:lineString];
       }
       NSString *result = [_data componentsJoinedByString:@","];
     NSMutableString *fullString = [[NSMutableString alloc]init];
       [fullString appendString:_name];
       [fullString appendString:@":"];
       [fullString appendString:result];
       [fullList replaceObjectAtIndex:removalIndex withObject:fullString];
       [fullList writeToFile:fullPath atomically:YES];

       [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)editMode
{
  if (self.tableView.isEditing == NO)
  {
     [self.tableView setEditing: YES animated:YES];
     self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"Done", @"Done");
  }
  else
  {
     [self.tableView setEditing: NO animated:YES];
     self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"Edit", @"Edit");
  }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        UIAlertController *alertController = [UIAlertController
                            alertControllerWithTitle:@"Enter new word"
                                             message:@""
                                      preferredStyle:UIAlertControllerStyleAlert];

        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
         {
           textField.placeholder = NSLocalizedString(@"", @"");
         }];

         [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    UITextField *textField = alertController.textFields[0];
    NSString *newWord = textField.text;
        if (![newWord isEqualToString:@""])
    [self addWord:newWord];
    else
           [self.tableView reloadData];

}]];
    [self presentViewController:alertController animated:YES completion:nil];
      }
  //    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

-(void)addWord:(NSString *)word
{
       NSString *fullPath = @"/var/mobile/Library/gotyourback/whitelist.plist";
       NSMutableArray *fullList = [[NSMutableArray alloc] initWithContentsOfFile:fullPath];
       NSMutableArray *whitelistWords = [NSMutableArray new];
//        NSlog(fullList);
//        NSlog(whitelistWords);
       int removalIndex = 0;
       for (NSString *lineString in fullList)
       {
          NSArray *tempArray = [lineString componentsSeparatedByString:@":"];
          if ([tempArray[0] isEqualToString:_name])
          {
              removalIndex = [fullList indexOfObject:lineString];
              tempArray = [tempArray[1] componentsSeparatedByString:@","];
              for (NSString *loadedWord in tempArray)
                  [whitelistWords addObject:loadedWord];
          }
       }
       [whitelistWords addObject:[word lowercaseString]];
       NSString *result = @"";
       if (whitelistWords.count>1)
           result = [whitelistWords componentsJoinedByString:@","];
       else
    result = whitelistWords[0];
     NSMutableString *fullString = [[NSMutableString alloc]init];
       [fullString appendString:_name];
       [fullString appendString:@":"];
       [fullString appendString:result];
//               NSlog(fullList);
//        NSlog(whitelistWords);
//        NSlog(fullString);
       if (fullList.count>0){
       [fullList replaceObjectAtIndex:removalIndex withObject:fullString];
              [fullList writeToFile:fullPath atomically:YES];}
       else {
       NSMutableArray *newList = [NSMutableArray new];
    [newList addObject:fullString];
           [newList writeToFile:fullPath atomically:YES];
}
         _data = [whitelistWords copy];
         triggerWords = _data;
       [self.tableView reloadData];
}
@end

%group messages
//iOS 10
%hook CKChatController
-(void)viewWillAppear:(BOOL)animated
{
       if ([self isKindOfClass:%c(CKComposeChatController)])
            return %orig;
       NSString *name = self.conversation.name;
       // Load blacklist
       NSMutableString *fullPath = [[NSMutableString alloc]init];
       [fullPath appendString:@"/var/mobile/Library/gotyourback/"];
       [fullPath appendString:name];
       [fullPath appendString:@".plist"];
       blacklistArray = [[NSMutableArray alloc] initWithContentsOfFile:fullPath];
       triggerWords = [blacklistArray copy];
       if (!triggerWords){
            [triggerWords writeToFile:fullPath atomically:YES];
          }
        // Load whitelist
        NSMutableArray *fullWords = [NSMutableArray new];
        if (triggerWords.count>0)
           fullWords = [triggerWords mutableCopy];
        whitelistArray = [NSMutableArray new];
        NSString *otherFullPath = @"/var/mobile/Library/gotyourback/whitelist.plist";
        NSMutableArray *fullList = [[NSMutableArray alloc] initWithContentsOfFile:otherFullPath];
        if (fullList.count<1){
        	[whitelistArray writeToFile:otherFullPath atomically:YES];
        }
        for (NSString *lineString in fullList)
        {
           NSArray *tempArray = [lineString componentsSeparatedByString:@":"];
           if (![tempArray[0] isEqualToString:name])
           {
               NSArray *wordArray = [tempArray[1] componentsSeparatedByString:@","];
               for (NSString *word in wordArray)
                   [whitelistArray addObject:word];
           }
        }
        for (NSString *words in whitelistArray)
            [fullWords addObject:words];
        triggerWords = [fullWords copy];
}
-(void)messageEntryViewSendButtonHit:(CKMessageEntryView*)arg1
{
       NSString *messageString = arg1.contentView.textView.text;
       NSString *name = self.conversation.name;
       NSMutableString *fullPath = [[NSMutableString alloc]init];
       [fullPath appendString:@"/var/mobile/Library/gotyourback/"];
       [fullPath appendString:name];
       [fullPath appendString:@".plist"];
       triggerWords = [[NSMutableArray alloc] initWithContentsOfFile:fullPath];
       // Load whitelist
        NSMutableArray *fullWords = [NSMutableArray new];
        if (triggerWords.count>0)
           fullWords = [triggerWords mutableCopy];
        whitelistArray = [NSMutableArray new];
        NSString *otherFullPath = @"/var/mobile/Library/gotyourback/whitelist.plist";
        NSMutableArray *fullList = [[NSMutableArray alloc] initWithContentsOfFile:otherFullPath];
        whitelistPeople = fullList;
        for (NSString *lineString in fullList)
        {
           NSArray *tempArray = [lineString componentsSeparatedByString:@":"];
           if (![tempArray[0] isEqualToString:name])
           {
               NSArray *wordArray = [tempArray[1] componentsSeparatedByString:@","];
               for (NSString *word in wordArray)
                   [whitelistArray addObject:word];
            }
        }
        for (NSString *words in whitelistArray)
            [fullWords addObject:words];
        triggerWords = [fullWords copy];
       BOOL triggered = NO;
       if (triggerWords.count>0){
        for (NSString *phrase in triggerWords)
        {
                if ([[messageString lowercaseString] containsString:phrase] && !triggered &&!sendThat)
            	 	{
                  triggered = YES;
                  NSString *message = @"'";
                  message = [message stringByAppendingString:phrase];
                  NSString *whitelistName = @"";
                  if ([whitelistArray containsObject:phrase]){
                  for (NSString *line in whitelistPeople){
                  	if ([line containsString:phrase]){
           NSArray *tempArray = [line componentsSeparatedByString:@":"];
           whitelistName = tempArray[0];}
                  }
                     message = [message stringByAppendingString:@"' is a whitelisted word for "];
                  message = [message stringByAppendingString:whitelistName];   }
                  else
                     {message = [message stringByAppendingString:@"' is a blacklisted word for "];
                  message = [message stringByAppendingString:name];}
                  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Hold up!" message:message preferredStyle:UIAlertControllerStyleAlert];

                  [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

                  }]];

                  [alertController addAction:[UIAlertAction actionWithTitle:@"Send anyway" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                    [self sendAnyway];
            }]];
                  [self presentViewController:alertController animated:YES completion:nil];
              }
         }}
    if (sendThat || !triggered){
       %orig(arg1);
       sendThat = NO;}
}
%new
-(void)sendAnyway
{
       sendThat = YES;
       [self messageEntryViewSendButtonHit:self.entryView];
}
%end

%hook CKDetailsController
%property (nonatomic, retain) CKTranscriptDetailsResizableCell *blacklistCell;
%property (nonatomic, retain) CKTranscriptDetailsResizableCell *whitelistCell;
-(id)initWithConversation:(CKConversation *)conversation
{
       self.whitelistCell = [[NSClassFromString(@"CKTranscriptDetailsResizableCell") alloc] initWithStyle:0 reuseIdentifier:@"resizable_cell"];
       self.whitelistCell.textLabel.text = @"Whitelisted words";
       self.whitelistCell.textLabel.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];

      self.blacklistCell = [[NSClassFromString(@"CKTranscriptDetailsResizableCell") alloc] initWithStyle:0 reuseIdentifier:@"resizable_cell"];
       self.blacklistCell.textLabel.text = @"Blacklisted words";
       self.blacklistCell.textLabel.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];

       return %orig;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 3)
      return 4;
    else
      return %orig;
}

-(id)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3 && indexPath.row == 2)
         return self.blacklistCell;
    else if (indexPath.section == 3 && indexPath.row == 3)
         return self.whitelistCell;
    else
        return %orig;
    %log(indexPath);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
       NSString *name = self.conversation.name;
      NSMutableString *fullPath = [[NSMutableString alloc]init];
       [fullPath appendString:@"/var/mobile/Library/gotyourback/"];
       [fullPath appendString:name];
       [fullPath appendString:@".plist"];
       blacklistArray = [[NSMutableArray alloc] initWithContentsOfFile:fullPath];
       whitelistArray = [NSMutableArray new];
       NSString *otherFullPath = @"/var/mobile/Library/gotyourback/whitelist.plist";
       NSMutableArray *fullList = [[NSMutableArray alloc] initWithContentsOfFile:otherFullPath];
       for (NSString *lineString in fullList)
       {
          NSArray *tempArray = [lineString componentsSeparatedByString:@":"];
          if ([tempArray[0] isEqualToString:name])
          {
              tempArray = [tempArray[1] componentsSeparatedByString:@","];
              for (NSString *word in tempArray)
                  [whitelistArray addObject:word];
          }
       }
       NSIndexPath *blacklistPath = [NSIndexPath indexPathForRow:2 inSection:3];
       NSIndexPath *whitelistPath = [NSIndexPath indexPathForRow:3 inSection:3];
       if (indexPath == blacklistPath)
             [self.navigationController pushViewController:[[blacklistController alloc] initWithName:self.conversation.name withData:blacklistArray] animated:YES];
      else if (indexPath == whitelistPath)
             [self.navigationController pushViewController:[[whitelistController alloc] initWithName:self.conversation.name withData:whitelistArray] animated:YES];
        %orig;
}
%end
%end //end messages10

%group messages9
//iOS 9
%hook CKTranscriptController
-(void)viewDidAppear:(BOOL)arg1
{
	    	CKConversation *converse = MSHookIvar< CKConversation*>(self,"_conversation");
        MNTitle = converse.name;
        %orig(arg1);
}
-(void)messageEntryViewSendButtonHit:(CKMessageEntryView*)arg1
{
        NSString *messageString = arg1.contentView.textView.text;
        BOOL triggered = NO;

        for (NSString *phrase in triggerWords)
        {
                if ([[messageString lowercaseString] containsString:phrase] && !triggered)
            	 	{
                  triggered = YES;
                //  %log(@"triggered");
                  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Hold up!" message:@"It looks like you're about to use a blacklisted word for [Name]" preferredStyle:UIAlertControllerStyleAlert];

                  [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                      [self closeAlertView];
                  }]];

            [alertController addAction:[UIAlertAction actionWithTitle:@"Send anyway" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                    [self closeAlertView];
            }]];
//%log(@"about to present");
    //      [self presentViewController:alertController animated:YES completion:nil];
              }
         else
                return %orig(arg1);
         }
       %orig(arg1);
}
%new
-(void)closeAlertview
{
//  [viewController dismissViewControllerAnimated:YES completion:nil];
}
%new
-(void)sendAnyway
{
       [self messageEntryViewSendButtonHit:self.entryView];
}
%end

%hook CKTranscriptManagementController
%property (nonatomic, retain) CKTranscriptDetailsResizableCell *blacklistCell;
%property (nonatomic, retain) CKTranscriptDetailsResizableCell *whitelistCell;
-(id)initWithConversation:(CKConversation *)conversation
{
       self.whitelistCell = [[NSClassFromString(@"CKTranscriptDetailsResizableCell") alloc] initWithStyle:0 reuseIdentifier:@"resizable_cell"];
       self.whitelistCell.textLabel.text = @"Whitelisted words";
       self.whitelistCell.textLabel.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];

      self.blacklistCell = [[NSClassFromString(@"CKTranscriptDetailsResizableCell") alloc] initWithStyle:0 reuseIdentifier:@"resizable_cell"];
       self.blacklistCell.textLabel.text = @"Blacklisted words";
       self.blacklistCell.textLabel.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];

       return %orig;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 3)
      return 4;
    else
      return %orig;
}

-(id)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3 && indexPath.row == 2)
         return self.blacklistCell;
    else if (indexPath.section == 3 && indexPath.row == 3)
         return self.whitelistCell;
    else
        return %orig;
    %log(indexPath);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
       NSString *name = self.conversation.name;
      NSMutableString *fullPath = [[NSMutableString alloc]init];
       [fullPath appendString:@"/var/mobile/Library/gotyourback/"];
       [fullPath appendString:name];
       [fullPath appendString:@".plist"];
       blacklistArray = [[NSMutableArray alloc] initWithContentsOfFile:fullPath];
       whitelistArray = [NSMutableArray new];
       NSString *otherFullPath = @"/var/mobile/Library/gotyourback/whitelist.plist";
       NSMutableArray *fullList = [[NSMutableArray alloc] initWithContentsOfFile:otherFullPath];
       for (NSString *lineString in fullList)
       {
          NSArray *tempArray = [lineString componentsSeparatedByString:@":"];
          if ([tempArray[0] isEqualToString:name])
          {
              tempArray = [tempArray[1] componentsSeparatedByString:@","];
              for (NSString *word in tempArray)
                  [whitelistArray addObject:word];
          }
       }
       NSIndexPath *blacklistPath = [NSIndexPath indexPathForRow:2 inSection:3];
       NSIndexPath *whitelistPath = [NSIndexPath indexPathForRow:3 inSection:3];
       if (indexPath == blacklistPath)
             [self.navigationController pushViewController:[[blacklistController alloc] initWithName:self.conversation.name withData:blacklistArray] animated:YES];
      else if (indexPath == whitelistPath)
             [self.navigationController pushViewController:[[whitelistController alloc] initWithName:self.conversation.name withData:whitelistArray] animated:YES];
        %orig;
}
%end
%end //end messages9 group

//---------------------------------------------
//static _UISecureHostedWindow *replyView;
%group messageBanner10
/*%hook _UISecureHostedWindow
-(void)viewWillAppear:(BOOL)animated
{
  %log(@"hello from reply vew");
  replyView = self;
}
%end*/
%hook CKNotificationChatController
-(void)viewWillAppear:(BOOL)animated
{
       NSString *name = self.conversation.name;
       NSMutableString *fullPath = [[NSMutableString alloc]init];
       [fullPath appendString:@"/var/mobile/Library/gotyourback/"];
       [fullPath appendString:name];
       [fullPath appendString:@".plist"];
       triggerWords = [[NSMutableArray alloc] initWithContentsOfFile:fullPath];
       if (!triggerWords){
            triggerWords = @[];
            [triggerWords writeToFile:fullPath atomically:YES];
          }
                  NSString *otherFullPath = @"/var/mobile/Library/gotyourback/whitelist.plist";
        NSArray *fullList = [[NSArray alloc] initWithContentsOfFile:otherFullPath];
        if (!fullList){
        	fullList = @[];
        	[fullList writeToFile:otherFullPath atomically:YES];
        }

}
-(void)messageEntryViewSendButtonHit:(CKMessageEntryView*)arg1
{
       NSString *messageString = arg1.contentView.textView.text;
       NSString *name = self.conversation.name;
       NSMutableString *fullPath = [[NSMutableString alloc]init];
       [fullPath appendString:@"/var/mobile/Library/gotyourback/"];
       [fullPath appendString:name];
       [fullPath appendString:@".plist"];
       triggerWords = [[NSMutableArray alloc] initWithContentsOfFile:fullPath];
              // Load whitelist
        NSMutableArray *fullWords = [triggerWords mutableCopy];
        whitelistArray = [NSMutableArray new];
        NSString *otherFullPath = @"/var/mobile/Library/gotyourback/whitelist.plist";
        NSMutableArray *fullList = [[NSMutableArray alloc] initWithContentsOfFile:otherFullPath];
        whitelistPeople = fullList;
        for (NSString *lineString in fullList)
        {
           NSArray *tempArray = [lineString componentsSeparatedByString:@":"];
           if (![tempArray[0] isEqualToString:name])
           {
               NSArray *wordArray = [tempArray[1] componentsSeparatedByString:@","];
               for (NSString *word in wordArray)
                   [whitelistArray addObject:word];
            }
        }
        for (NSString *words in whitelistArray)
            [fullWords addObject:words];
        triggerWords = [fullWords copy];
       BOOL triggered = NO;
       if (triggerWords.count>0){
        for (NSString *phrase in triggerWords)
        {
                if ([[messageString lowercaseString] containsString:phrase] && !triggered &&!sendThat)
            	 	{
                  triggered = YES;
                  NSString *message = @"'";
                  message = [message stringByAppendingString:phrase];
                  NSString *whitelistName = @"";
                  if ([whitelistArray containsObject:phrase]){
                  for (NSString *line in whitelistPeople){
                  	if ([line containsString:phrase]){
           NSArray *tempArray = [line componentsSeparatedByString:@":"];
           whitelistName = tempArray[0];}
                  }
                     message = [message stringByAppendingString:@"' is a whitelisted word for "];
                  message = [message stringByAppendingString:whitelistName];   }
                  else
                     {message = [message stringByAppendingString:@"' is a blacklisted word for "];
                  message = [message stringByAppendingString:name]; }
                  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Hold up!" message:message preferredStyle:UIAlertControllerStyleAlert];

                  [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

                  }]];

                  [alertController addAction:[UIAlertAction actionWithTitle:@"Send anyway" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                    [self sendAnyway];
            }]];
              //%log([[UIApplication sharedApplication] windows]);
                  [[[UIApplication sharedApplication] windows][0].rootViewController presentViewController:alertController animated:YES completion:nil];
              }
         }}
    if (sendThat || !triggered){
       %orig(arg1);
       sendThat = NO;}
}
%new
-(void)sendAnyway
{
       sendThat = YES;
       [self messageEntryViewSendButtonHit:self.entryView];
}
%end
%end//end group messageBanner10


//Beta support for iOS 9 (hard without a device)
%group messageBanner9
%hook CKInlineReplyViewController
/*- (void)messageEntryViewSendButtonHit:(CKMessageEntryView *)entryView
{
      NSString *messageString = entryView.contentView.textView.text;
      NSDictionary *messageContext = self.context;// MSHookIvar<NSDictionary *>(self,"_context");
      //[messageContext writeToFile:@"/var/mobile/Library/betherein5/context.plist" atomically:YES];
      NSDictionary *assistantContext =  messageContext[@"AssistantContext"];
      NSDictionary *msgSender = assistantContext[@"msgSender"];
      NSDictionary *object = msgSender[@"object"];
      NSString *name = object[@"firstName"] ?: @"Robert";

    for (NSString *phrase in triggerWords)
    {
            if ([[messageString lowercaseString] containsString:phrase] && !triggered){
    	 	       startTimer(messageString, self, NO, name);
             }
    }
	        %log(entryView.contentView.textView.text);
    %orig(entryView);
}*/
-(void)viewWillAppear:(BOOL)animated
{
       NSString *name = @"Rob";//self.conversation.name;
       NSMutableString *fullPath = [[NSMutableString alloc]init];
       [fullPath appendString:@"/var/mobile/Library/gotyourback/"];
       [fullPath appendString:name];
       [fullPath appendString:@".plist"];
       triggerWords = [[NSMutableArray alloc] initWithContentsOfFile:fullPath];
       if (!triggerWords){
            triggerWords = @[];
            [triggerWords writeToFile:fullPath atomically:YES];
          }
                  NSString *otherFullPath = @"/var/mobile/Library/gotyourback/whitelist.plist";
        NSArray *fullList = [[NSArray alloc] initWithContentsOfFile:otherFullPath];
        if (!fullList){
        	fullList = @[];
        	[fullList writeToFile:otherFullPath atomically:YES];
        }

}
-(void)messageEntryViewSendButtonHit:(CKMessageEntryView*)arg1
{
       NSString *messageString = arg1.contentView.textView.text;
      NSDictionary *messageContext = self.context;
      [messageContext writeToFile:@"/var/mobile/Library/context.plist" atomically:YES];
       NSString *name = @"Rob";//self.conversation.name;
       NSMutableString *fullPath = [[NSMutableString alloc]init];
       [fullPath appendString:@"/var/mobile/Library/gotyourback/"];
       [fullPath appendString:name];
       [fullPath appendString:@".plist"];
       triggerWords = [[NSMutableArray alloc] initWithContentsOfFile:fullPath];
              // Load whitelist
        NSMutableArray *fullWords = [triggerWords mutableCopy];
        whitelistArray = [NSMutableArray new];
        NSString *otherFullPath = @"/var/mobile/Library/gotyourback/whitelist.plist";
        NSMutableArray *fullList = [[NSMutableArray alloc] initWithContentsOfFile:otherFullPath];
        whitelistPeople = fullList;
        for (NSString *lineString in fullList)
        {
           NSArray *tempArray = [lineString componentsSeparatedByString:@":"];
           if (![tempArray[0] isEqualToString:name])
           {
               NSArray *wordArray = [tempArray[1] componentsSeparatedByString:@","];
               for (NSString *word in wordArray)
                   [whitelistArray addObject:word];
            }
        }
        for (NSString *words in whitelistArray)
            [fullWords addObject:words];
        triggerWords = [fullWords copy];
       BOOL triggered = NO;
       if (triggerWords.count>0){
        for (NSString *phrase in triggerWords)
        {
                if ([[messageString lowercaseString] containsString:phrase] && !triggered &&!sendThat)
            	 	{
                  triggered = YES;
                  NSString *message = @"'";
                  message = [message stringByAppendingString:phrase];
                  NSString *whitelistName = @"";
                  if ([whitelistArray containsObject:phrase]){
                  for (NSString *line in whitelistPeople){
                  	if ([line containsString:phrase]){
           NSArray *tempArray = [line componentsSeparatedByString:@":"];
           whitelistName = tempArray[0];}
                  }
                     message = [message stringByAppendingString:@"' is a whitelisted word for "];
                  message = [message stringByAppendingString:whitelistName];   }
                  else
                     {message = [message stringByAppendingString:@"' is a blacklisted word for "];
                  message = [message stringByAppendingString:name]; }
                  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Hold up!" message:message preferredStyle:UIAlertControllerStyleAlert];

                  [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

                  }]];

                  [alertController addAction:[UIAlertAction actionWithTitle:@"Send anyway" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                    [self sendAnyway];
            }]];
              //%log([[UIApplication sharedApplication] windows]);
                  [[[UIApplication sharedApplication] windows][0].rootViewController presentViewController:alertController animated:YES completion:nil];
              }
         }}
    if (sendThat || !triggered){
       %orig(arg1);
       sendThat = NO;}
}
%new
-(void)sendAnyway
{
       sendThat = YES;
       [self messageEntryViewSendButtonHit:self.entryView];
}
%end
%end //end message banner


%ctor
{
    NSString *pathForFile = @"/var/mobile/Library/gotyourback";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:pathForFile]){
    		[fileManager createDirectoryAtPath: pathForFile    withIntermediateDirectories:YES   attributes:nil   error:nil];}

    @autoreleasepool {
    NSString *bundleIdentifier = [NSBundle mainBundle].bundleIdentifier;

  if ([bundleIdentifier isEqualToString:@"com.apple.MobileSMS.notification"])
     %init(messageBanner9);

    if ([bundleIdentifier isEqualToString:@"com.apple.MobileSMS.MessagesNotificationExtension"])
      %init(messageBanner10);

	  if ([bundleIdentifier isEqualToString:@"com.apple.MobileSMS"])
	 	{
	 	 	if (kCFCoreFoundationVersionNumber < 1300.0 ) //1300 is iOS 10
	 	 		%init(messages9);
	 		else
		  		%init(messages);
		}
    }
}
