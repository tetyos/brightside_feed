

/// In this file the json-identifier needed for communication with the backend can be found.

// Item Model
const String itemId = "_id";

// SearchQuery:

const String searchQuery_SortBy_DateAdded = 'dateAdded';
const String searchQuery_SortBy_DatePublished = 'datePublished';
const String searchQuery_SortBy_lastVoteOn = 'lastVoteOn';

// Voting Model
const String votesArray = 'votes';

const String postVote_ItemId_Key = "itemId";
const String postVote_VoteCategory_Key = "voteCategory";
const String postVote_IncreaseAmount_Key = "inc";

const String upVote = "upVote";
const String impactVote = "impactNom";
const String inspiringVote = "inspiringNom";
const String wellWrittenVote = "wellWrittenNom";

const String totalUpVotes = "upVotes";
const String totalImpactVotes = "impactNoms";
const String totalInspiringVotes = "inspiringNoms";
const String totalWellWrittenVotes = "wellWrittenNoms";

// Admin Actions
const String adminAction_ItemId_Key = "itemId";
const String adminAction_ActionType_Key = "actionType";

const String adminAction_deleteItem = "deleteItem";
const String adminAction_removeIncStatus = "removeIncStatus";
const String adminAction_removeUnsafeStatus = "removeUnsafe";