class RemoteConfig {
  static const loginUser = "user/verify-otp";
  static const registerUser = "user/register";
  static const sendOtp = "user/send-otp";
  static const getCategories = "campaign/list";
  static const getProfile = "user/profile";
  static const updateProfile = "user/update-profile";
  static const getHomeItems = "home/list";
  static const getAllFundraiserItems = "fundraiser-scheme/list";
  static const getAllCampaignRelatedItems = "fundraiser-scheme/campaigns-list";
  static const getSearchResults = "master/android-search";
  static const postContactUs = "contact-us/add-contact";
  static const addPartner = "partner/add-partner";
  static const createVolunteer = "volunteer-request/create-volunteer";
  static const getFundraiserDetail = "fundraiser-scheme/fundraiser-detail-api";
  static const getAllComments = "fundraiser-scheme-comment/list";
  static const getAllDonors = "fundraiser-scheme/top-donors";
  static const getAllSupporters = "fundraiser-scheme/supporters";
  static const addComment = "fundraiser-scheme-comment/add-comment";
  static const getMyComments = "fundraiser-scheme-comment/my-comments";
  static const getMyDonations = "fundraiser-scheme/donation-list";
  static const getMyFundraisers = "fundraiser-scheme/my-fundraisers";
  static const uploadDocument = "fundraiser-scheme/upload-document";
  static const removeDocument = "fundraiser-scheme/remove-document";
  static const getRelations = "master/relation-master";
  static const createFundraiser = "fundraiser-scheme/start-fundraiser";
  static const getPricingStrategies = "master/pricing";
  static const withdrawFundraiser = "fundraiser-scheme/withdraw";
  static const transferAmount = "razorpay/transfer";
  static const updateFundraiser = "fundraiser-scheme/update-fundraiser";
  static const getFaqItems = "faq/list";
  static const getMediaItems = "media/list";
  static const getOurTeam = "master/our-team";
  static const reportIssue = "report-issue/add";
  static const cancelFundraiser = "report-issue/cancel-fundraiser";

  // Loan & Lend related
  static const createLend = "loan/create-loan";
  static const updateLend = "loan/update-loan";

  static const getPointsInfo = "master/point";
  static const removeSubscription = "razorpay/cancel-subscription";

}
