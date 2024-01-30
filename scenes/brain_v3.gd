extends Node2D
# Signals  **********************************************************
#Emitted when a new type is selected to send info to guide script
signal itemSelected
#Emitted when regions are loaded to send them to the guide script
signal regionsReady
#Emitted when region is clicked to send to guide script
signal regionSelected


# Globals  **********************************************************


# Array of all personality type names
@onready var types = [
	"NeTi",
	"NeFi",
	"FiSe",
	"FiNe",
	"TiNe",
	"TiSe",
	"FeSi",
	"FeNi",
	"TeSi",
	"TeNi",
	"NiFe",
	"NiTe",
	"SiFe",
	"SiTe",
	"SeFi",
	"SeTi",
]
# Dictonary containing all activity level information for the types
@onready var intensity = {
	"NeTi": [
		["F3", "F4", "C3", "P3"],
		["F8", "T5", "T6", "O1"],
		["C4", "T4", "O2", "Fp1"],
		["Fp2", "F7", "T3", "P4"],
	],
	"NeFi": [
		["F3", "F4", "C3", "C4"],
		["T3", "P3", "P4", "O1"],
		["Fp1", "F8", "T5", "T6"],
		["Fp2", "F7", "T4", "O2"],
	],
	"FiSe": [
		["F3", "F4", "C3", "P4"],
		["F7", "P3", "C4", "T5"],
		["Fp2", "T3", "T4", "F8"],
		["Fp1", "O1", "O2", "T6"],
	],
	"FiNe": [
		["F3", "F4", "P3", "P4"],
		["O1", "C4", "C3", "T5"],
		["Fp2", "F7", "T6", "O2"],
		["Fp1", "F8", "T3", "T4"],
	],
	"TiNe": [
		["T4", "P3", "T5", "O2"],
		["T3", "C4", "P4", "T6"],
		["Fp2", "F7", "F8", "O1"],
		["Fp1", "F3", "F4", "C3"],
	],
	"TiSe": [
		["F3", "F4", "C3", "C4"],
		["F7", "F8", "T4", "T5"],
		["Fp2", "T3", "T6", "O1"],
		["Fp1", "P3", "O2", "P4"],
	],
	"FeSi": [
		["T4", "P3", "P4", "O2"],
		["F3", "F4", "C4", "F8"],
		["Fp2", "C3", "T6", "O1"],
		["Fp1", "F7", "T5", "T3"],
	],
	"FeNi": [
		["F3", "F4", "P3", "O1"],
		["F7", "F8", "C3", "P4"],
		["Fp2", "T4", "T6", "O2"],
		["Fp1", "T3", "C4", "T5"],
	],
	"TeSi": [
		["F4", "P3", "P4", "C4"],
		["T4", "T5", "T6", "O2"],
		["Fp2", "F7", "T3", "F3"],
		["Fp1", "F8", "C3", "O1"],
	],
	"TeNi": [
		["F7", "T5", "F3", "P3"],
		["F4", "C4", "P4", "T6"],
		["Fp2", "C3", "T4", "O2"],
		["Fp1", "F8", "T3", "O1"],
	],
	"NiFe": [
		["F3", "C3", "P3", "P4"],
		["F4", "C4", "T4", "O2"],
		["Fp1", "F7", "T5", "T6"],
		["Fp2", "F8", "T3", "O1"],
	],
	"NiTe": [
		["F3", "F4", "P3", "C4"],
		["F8", "C3", "T5", "P4"],
		["Fp1", "F7", "T4", "O2"],
		["Fp2", "T3", "T6", "O1"],
	],
	"SiFe": [
		["F7", "F4", "F8", "P4"],
		["F3", "C3", "P3", "T6"],
		["Fp1", "T3", "T4", "O1"],
		["Fp2", "C4", "T5", "O2"],
	],
	"SiTe": [
		["F4", "C3", "C4", "P4"],
		["F3", "T3", "T4", "T6"],
		["Fp1", "F7", "P3", "O2"],
		["Fp2", "F8", "T5", "O1"],
	],
	"SeFi": [
		["F3", "F4", "P4", "T5"],
		["T3", "P3", "T6", "O2"],
		["Fp1", "C3", "C4", "O1"],
		["Fp2", "F7", "F8", "T4"],
	],
	"SeTi": [
		["C3", "C4", "T5", "F8"],
		["F7", "T4", "T6", "O1"],
		["Fp1", "T3", "P3", "O2"],
		["Fp2", "F3", "F4", "P4"],
	],
}
# Dictionary containing all region summaries
@onready var region_summaries = {
	"Fp1": ["Provide a reason.", "Decide between options.", "Detect an error.", "Dismiss negative thoughts/information."],
	"Fp2": ["Notice which step you are on in a task.", "Perceive that you are done brainstorming", 'Consider a new or unpleasant idea.'],
	"F7": ["Imagine another place or time.", "Mirror other's behavior.", "Ask 'maybe' or 'what-if'.", "Mentally play out a situation."],
	"F3": ["Make logical deductions.", "Backtrack or otherwise correct your thinking due to a reasoning error.", "Follow a chain of reasoning."],
	"F4": ["Categorize a person, place, thing, event, or idea.", "Have a sense for how well a concept (e.g. dog, traffic, justice) fits a particular category.", "Link two concepts together."],
	"F8": ["Recall exact, literal details.", "Say a word or phrase with strong emphasis.", "Identify what we believe.", "Rate how much we like or dislike something.", "Ignore context."],
	"T3": ["Speak words.", "Compose complex sentences.", "Attend to proper grammar and word usage.", "Listen to other people's words."],
	"C3": ["Remember a fact.", "Retrieve a memory that contains specific information such as a date or time.", "Recall a sequence of action steps.", "Prepare to move your body's right side, such as to move your right hand.", "Skillfully draw charts, tables and diagrams.", "Attend to sensations on or within the right side of your body."],
	"C4": ["Remember a beautiful place.", "Retrieve a memory based on aesthetic qualities.", "Recall whole-body affect.", "Prepare to move your body's left side, such as to move your left hand.", "Skillfully draw realistic, free-hand illustrations", "Attend to sensations on or within the left side of your body."],
	"T4": ["Notice someone's tone of voice.", "Hear when something 'resonates' or 'speaks' to you personally", "Feel someone is speaking in a phony or false way but cannot say why.", "Speak with powerful affect."],
	"T5": ["Notice others' input about your social behavior.", "Are curious what someone thinks of you.", "Adjust your behavior in order to appease or conform to others' expectations", "Feel embarrassed."],
	"P3": ["Identify tangible objects.", "Use physical and visual cues to move your body.", "Attend to where you end and the rest of the world begins.", "Work on a problem using rote memorization."],
	"P4": ["Weigh numerous pros and cons.", "Calculate and compare various risks versus their likely rewards.", "Objectively evaluate many factors at once.", "Locate and apply leverate (influence)."],
	"T6": ["Say the word 'will'; as in, what whill occur in the future.", "Imagine yourself within a complex system.", "Notice abstract spatial-structural relationships.", "Assign a symbolic meaning.", "Envision your future."],
	"O1": ["Read a chart or diagram.", "Visually disassemble an object to visualize its components and how it works.", "Visualize how elements of an object will fit together to form a structure.", "Mentally rotate an object in your mind's eye."],
	"O2": ["View a photograph or painting.", "Sense how colors, shapes, and other elements fit aesthetically.", "Notice or set the theme of an illustration or a photograph.", "Gain an impression of a person's character from their appearance."]
}

# Dictionary containing all region descriptions
var region_descriptions = {
	"Fp1": "This region is like a high-powered executive ship's captain or Court Judge. It collects and integrates information from all regions to make and explain decisions. People use this region when they say, 'I think this because...' or 'I pick that one'. It literally lights up just fractions of a second before we speak or act. We may verbalize our reason or decision, or we may keep it to ourselves. Either way, the results come rapidly and with confidence. This region can help us concoct reasons that sound plausible or actions that look doable. It also detects errors and deviations from the norm, signaling when something is not right.
	This region activates to help us ignore unwanted ideas that are negative or undesirable so that we stay happy and positive. [p][/p]When we hear criticism, take in violent or depressing content, or are exposed to a disruptive ida, this region may easily come into play, directing our attention elsewhere. In a study by Ginette Blackhart, this region lit up when people decided to skip an introspective task. The task asked them to explore how a sad story they just read applied to their own lives. Conversely, this region was less active for people who introspected. Thus, it seems that happiness comes at the price of willful ignorance! 
	Statistically, more people use this region than any other. Those who under use this region may be slow to make decisions, struggle to provide explanations, and/or have difficulty noticing errors or screening out negative input. Also, criticism or unpleasant ideas may easily move them to sadness, anger, or fear.
	Using this region may frustrate us sometimes. Using it feels confident and quick, but its actual performance may be poor, a bad choice or illogical explanation, particularly when relying on it to ignore unwanted information.",
	"Fp2": "This region is like an ever-vigilant but hands-off facilitator or Taskmaster letting you know when to start, stop or try again. It gets active when we are exposed to new information and helps us process that information in a productive way. People use this region when they say \"I'm done\" or \"I can't think of any more ideas\". It fires fractions of a second before we note where we are in a process. Broadly, this region helps us track whether we are at the beginning, middle or end of a task for an open-ended activity like brainstorming or reliving a memory. It suggests stopping points, but it's flexible. You are welcome to keep exploring. Unlike region Fp1, this region is not very verbal or directed and it may quietly allow other regions of your brain to do their thing until it is time to move on.
	This region helps us explore and deal with information that is counter to what is typical or desirable. When we hear criticism or violent or depressing content or otherwise receive disruptive data, we can use this region to delve into that information considering its meaning and how it applies to us simultaneously, it helps us regulate our emotions so that we remain calm rather than getting angry. In one study this region lit up for people who decided to explore how a sad story they read applied to their own lives. This suggests that sadness and depression may be a price we pay for introspective living.
	[p][/p] People who under use this region may be impatient, preferring to focus on decision-making; and they may get sidetracked or erupt with bursts of hostility when called to grapple with odd or unpleasant input. Using this region may frustrate us sometimes. While using it we likely are in eloquent also over using this region may lead us astray as we delve into negatives or endlessly try a task without making decisions.",
	"F7": "This region is home to mirror neurons which are special cells. Using these cells we can watch a person perform a task or behave in a certain way and then mimic that person to quickly learn the task or act as if we are like them these cells also fire when we imagine doing something but don't actually act. This region acts as our minds very own Star Trek Hollow deck a place where we can play out real life and fanciful events.
	here's how it works we select the context which might be in the immediate situation before us a future event such as upcoming tests or race or a historical or imaginative context such as a childhood birthday party or ancient Rome then we play out the simulation perhaps asking what it this region does its best to supply details and simulate what would likely happen thus we can use this region to make sensible guesses consider the words car Road and Flat Tire now imagine a larger scene or several scenes perhaps an accident occurred who or what else is in the see how do people feel don't really answer the question just play as if it can also Supply you with additional words that fit the implied context, such as traffic, ambulance, or rain.
	[p][/p]People who under use this region may display a lack of empathy and find it hard to learn by imitation or inference puzzle over other's motives dislike what if questions and brainstorming and or feel challenged to think outside the box.
	this region is not analytical that we may feel like we are analyzing as we explore a myriad of scenarios simply it helps us make smart guesses based on context and imitation people who use this region with skill are able to quickly build rapport with others and make insightful guesses about people without having any particular reason or theory in mind their mental stimulation simply reveal what they need to know using this region May frustrate us Sometimes using it can be fun and provide ideas for why people act as they do however our inferences maybe wrong moreover while this region provides an appearance of empathy and Rapport the active mirroring others does not mean we truly care",
	"F3": "We can use this region to make a series of logical deductions. For example, \"If A equals B, and B equals C, then A equals C.\" That said, this region is a lot more complex than a simple syllogism suggests. Using this region is like climbing around a tree of many branches. We start at the trunk, and each logical deduction carries us along a branch to a new spot on another branch, until we reach the last branch and hopefully deduce an accurate conclusion. When we use this region, thedeductive process generates conclusions for us, whether we like them or not. Often we will need to backtrack to go in a more accurate direciton. This region also sits by key brain sites for speaking, making it very varbal, though we don't need to speak out loud to use it. Simply, use requires that we think in words or symbols (math, etc.) in a linear way and keep checking our logic at each step. Thus, this region requires more work than many poeple are trained for. In psychological experiments, people often say they are \"logical\" without fully appreciating what's required. Using F3, we don't just make-up reasons as we might using region Fp1. Truly, we deduct them.
	[p][/p]People who under-use this region may falter at deductive reasoning. A majority of people show less activity here than in other regions, suggesting that under-use is common. Moreover, regions like Fp1 and T3 can easily provide an illusion of sound thinking and accurate speech. Thus, a deficit may not show up in daily life unless the person works in a discipline that relies on deduction.
	Using this region may frustrate us sometimes. Accurate logical deduction takes work and patience for backtracking and self-correcting. Moreover, even when the reasoning is sound, a thought that is logical won't necessarily match empirical evidence.",
	"F4": "We use this region to classify and define concepts, which include just about anything and everything. For example, is a dolphin a fish or a mammal? Is a particular cell specimen cancerous or benign? Or is your new colleague a competitor or an ally, according to some definition of these terms? To understand this region, imagine a wall of mailboxes for an apartment building. Each box is assigned to someone. You can use this region to place various arriving letters into the correct boxes or notice when a letter is in the wrong box. This region isn't eloquent like region F3. It doesn't get involved in grammar or crafting sentences, yet it knows labels such as \"marine mammals\" very well.",
	"F8": "This region gets active when you say what's important to you in life. A musician, when talking about music, might slightly emphasize words like \"guitar\" or \"my song\". Similarly, consider friends and relatives. Say their names and what you like or respect (or not) about them. Who do you like more? Or consider, what are your values? Can you name them? Everyone has words or phrases that predictably light up this region. The actual words vary by individual. Knowing these could provide great insight into the people and events that have likely shaped a person. By the way, people tend to show more activity here when mentioning the parent of the same sex regardless of how pleased they are with that parent. Also, for some people, this region is really active when they focus on what they dislike or don't believe, rather than what they like or believe!
	This region guides our speech and behavior to fit what we have grown to identify as important and worth believing in, including religious convictions, personal values, and loved-ones. This region also helps us recall literal details. You may wonder how beliefs and details relate. Consider, this region lies opposite region F7. Just as F7 allows us to think contextually, this region ignores context.
	When someone or something is truly important and worth believing in, then that importance transcends context. Most of us have had the experience of easily and accurately recalling what we care about! Baseball fans easily recall reams of baseball data, for example. So in general, while some people may have ahead for details and yet lack ideological conviction, or vice versa, there is a natural link between what we recall in detail and what we set as always valuable. The box on the next page about autism goes into more detail about this link.
	[p][/p]People who under-use this region may have difficulty accurately recalling details, or they may lack grounding in a lasting identity of solid attitudes and beliefs. To them, everything is contextual and therefore relative. They may value the act of holding values more than attending to the details of those values. Using this region may frustrate us sometimes. It can lead us astray when we focus on beliefs over evidence, or focus too much on details over a big picture.",
	"T3": "This region handles words, both your words and those spoken by others. It lies next to and feeds
	into key brain areas that process spoken language. It concerns itself with proper word choice, grammar and usage, and other technical elements of language. When you use this region to listen to people, you listen for how they use their words and focus on content in general. Consider the difference between, \"he visited the house\" and \"he stayed at her house\". There is a slight but critical distinction between the words \"visited\" and \"stayed\"; moreover, the choice of \"the\" over \"her\" is a minor change of meaning. This region does not handle tone of voice or other aesthetic qualities of language. We use this region to handle any tasks we've learned to do by speaking. For example, if you were taught to do mathematics by saying numbers to yourself, then you are likely using this region to do math! A big challenge: this region handles both listening and speaking. Thus, if you tend to talk to yourself in order to think (solve math problems, etc.), then you will likely find a noisy environment seriously distracts your thought process. When this happens, you may find that you cannot think clearly and interact with others at the same time. Although the spoken word feels essential to human activity, some people do not use this region much. They don't talk to themselves. They may think in symbols or pictures or even sensations. Similarly, when someone else starts talking, they may quickly tune out unless they judge the content as highly relevant.
	[p][/p]Using the region can frustrate us sometimes. The ability to use words in a precise way is not related to thinking logically. Though some reasoning regions like F3 are close by, others like F4 and P4 are far away and mostly nonverbal. Fine speech can provide an illusion of reason. Also, we may get caught up in selecting just the right grammar or split hairs about the meanings of sentences.",
	"C3": "This region handles sensations and motor movement of the body's right side. Sensation includes both touch and internal sensations (called proprioception) such as pain or hunger. Strenuous activities, such as manual labor and dancing, and some sedentary activities such as sewing or drawing, engage this region. Sadly, a lab environment offers few opportunities to move around. Multiple studies confirm that this region is organized using a homunculus. That is, neurons are laid out in a way that mimics the actual bipedal layout of the body, with neurons handling the face, neck, chest, arms, hands, torso, legs, feet and so on. This region may also activate when you retrieve factual memories like birth dates and textbook knowledge that can be discussed such as what year Columbus first arrived in the Americas. If I were to ask you to name various American presidents or recall how many windows are on the front of your house, there is a good chance this region will briefly reflect the fetching of data from your \"memory storekeeper\", which is a region called the hippocampus that lies deep down in the brain rather than in the neocortex. It is important to know that this memory works \"Batch\" style. Imagine two ways to watch a movie clip on the Internet. Either you completely down-
	load the clip and then watch it, or you stream it in, watching it as it downloads. The former is called \"batch\" and that's how the brain works. When you wish to recall a memory, this region retrieves the whole memory for you, or at least a sizable chunk. This retrieval occurs in a jiffy! Then this region goes quiet as you use the memory. Similarly, with regard to motion, the act of moving does not, in and of itself, activate this region. Instead, this region prepares you for such movement, especially if you require precision or are trying a new move. For example, if you have never juggled a ball or shuffled a deck of cards before, then this region will briefly activate fractions of a second before you do so. Although deep areas of the brain handle much of memory and motion, this region gets involved. Often, memory and motion are more closely linked than many people realize, particularly when we need to recall facts related to body motion such as dance steps. Reflect on how you pose your body when you learn something. Do you find that sitting, with pencil in hand, suddenly releases some facts that weren't so available when you were standing? Thus, how we pose our body when we learn affects how we best recall facts. [p][/p]People who under-use this region tend to easily forget or confuse facts. Some may have difficulty using the right side of their body and may show poor hand-eye or hand-foot coordination, such as difficulty executing dance steps. Sometimes this region can frustrate us when we find we cannot recall information with the speed or accuracy that we may like.",
	"C4": "In most ways, this region is the mirror image of region C3. It attends to the left side of your body rather than your right side. It is also organized like a little homunculus, with neurons neatly laid out from head to toe, with more neurons devoted to the more sensitive regions of the body. Like C3, it gets involved when you access memories. That said, this region lies in the right hemisphere and is more holistic. If region C3 becomes active when we recall factual data like someone's birthday, then C4 becomes active when we recall the most beautiful place we have ever visited. The word \"beautiful\" is a lot less precise than a calendar date! Fortunately, region F4 is next door and ready to check whether a memory falls into the beautiful category.
	This region is also home to fluid body motion and affect, which is no surprise since region T4, which handles tone of voice, is also next door. Imagine dancing to rock music by improvising moves rather than following steps. When done well, the improvised moves are in synch with the rhythm of the music and not predictable. This region helps the dancer maintain an elegant, entertaining style. Generally this region also gets active when we need to use both sides of our body rather than our preferred side. For example, playing a piano usually requires two hands, each coordinating but doing its own moves. One of the clearest ways that this region gets active is when we draw, whether we do precision drawing for realism or more abstract drawing for cartoons and such. 
	[p][/p]People who under-use this region often show poor artistic skill and perhaps lack smooth body motion. After primary school, education tends to steer people away from these skills; and when these skills are not highly valued in a society, an adult may not miss much. Lab experiments demonstrate that small harmless electrical bursts to the left hemisphere can suddenly allow regions in the right hemisphere such as this one to become more active; people suddenly gain (or re-gain) artistic ability for several hours until the effect ends. This suggests that many of us may have more access to this region than we realize.
	This region is entirely nonverbal and thus can be tricky to identify or express what is occurring under its watch, which may frustrate us at times.",
	"T4": "This region handles tone of voice and other affective qualities of sound and voice. It lies next to regions that handle personal identity, belief, and aesthetic sensibilities all phenomena that are often hard to articulate yet easily conveyed through affect, particularly one's tone. When we use this region, we mostly focus on how something is said rather than the specific words used, though this region does respond to specific words that resonate with our beliefs and identity. This region would likely light up when a musician hears the word \"music\" because of the word's importance to that person. This region is more critical for social interaction and language than some folks might imagine. For example, someone might say, \"I love you\" with genuinely deep affection, or with off-handed sarcasm, or in a perfunctory robotic way. Similarly, consider how shallow or misleading e-mail can be. Though email can communicate many words, people tend to resort to brief asides or emoticons such as a smiley face or winking face in order to convey the tone of what's said. Without those cues, we may easily misinterpret what others say. Accounting for others' intentions shows here. We can focus on someone's motivations, such as noting that a criminal suspect is guilty of bad intent even through he was caught and ultimately failed to get away with his crime. This region holds a dark secret. It is home to irritation and hostility. This region becomes active when people get annoyed or outright angry and cannot subdue their anger, particularly when they hear an offending word. Normally, we rely on regions Fp1 and Fp2 to help us manage our emotions, where Fp1 provides happiness (but we remain ignorant) and Fp2 provides sadness (if we take time to introspect). When neither of these regions is working for us, the result is anger when criticized.
	[p][/p]People who under-use this region tend to miss voice tone, both out of their own mouths and from others. They likely rely on analyzing word content and thus think they understand what is said, but may miss key information such as how the speaker feels about them, or whether a statement was a joke or for real. The person may also use a monotone voice, dispiriting or confusing his listeners.
	This region can sometimes frustrate us when we respond intuitively to words, but the content of the words is misleading or factually wrong. We might be led to believe what someone says just because it \"sounds good\" or has been carefully framed to speak to our values.",
	"T5": "Like region F7, this region contains \"mirror neurons\", clusters of special cells that help us imagine what others are up to and respond to their input appropriately. If F7 is about mimicking or imagining
	people's physical actions, this region focuses on social behavior.
	[p][/p]When we use this region, we focus on others' judgments regarding the appropriateness of our behavior. When someone scowls at you, shows you a pleasant smile, utters a reprimand or compliment, or otherwise provides you with feedback, you can respond in several ways. First, you might simply note the person's feedback and choose to ignore it. But more likely, using this region, you adjust your behavior to get more positive feedback or to change the negative feedback into a positive. This region actively encourages us to change our behavior by supplying us with feelings of embarrassment and possibly shame. We might also blush or feel flustered. Calling attention to blushing or other reaction promotes this region's activity even more, in a spiral of ever-greater self-consciousness and embarrassment. This region is not just about pleasing people we care about; it attends to strangers' expectations and input. Thus, using this region tends to assure pleasant social relations, perhaps at the expense of one's own needs and desires. People who use this region a lot tend to be highly sensitive to others and easily insulted or elated.
	This region can activate when we know we are being watched but haven't yet received feedback and wonder what others are thinking. For some people, this region is most active when they wonder like this; activity then stops once they receive the actual feedback. They are attentive to what is not said and are unlikely to adjust their behavior to social expectations.
	Studies suggest this region helps men but not women to distinguish other people's faces in analytical way. Women rely more on region T6 instead. [p][/p]People with low activity in this region tend to either not notice others' feedback or simply choose to not respond. That said, few people are entirely immune to social feedback; and when this region does come into play for them, its output may be so profuse that it spills over into neighboring regions. One neighbor is region P3, which facilitates one's sense of self. A person who is normaly an \"independent free thinker\" may suddenly find herself blushing, highly self-conscious, and perhaps somewhat uncoordinated.
	Sometimes this region can frustrate us. It is challenging to \"just ignore\" input when this region is encouraging us to conform",
	"P3": "This region is the seat of the physical sense of self in the environment. Specifically, it really helps us integrate visual and kinesthetic cues to guide how we move our bodies. When there is a lot of activity in this region, we experience the world as a giant grid of space in which we can see and act. It's a wonderful resource for physical activities that require tactical moves. For example, a basketball player must track himself, teammates and opponents, the ball, guidelines on the floor, distance to the net, and so forth. The better this region works, the faster we integrate a multitude of visual and kinesthetic inputs in order to act with rapid precision. The act of tossing a basketball into the net while opponents are moving at the same time is perhaps a high point when using this region. Unfortunately, EEG does not yet allow us to watch people's brains as they play sports, so this is speculative. Perhaps in the future! Where I do see similar results is when subjects use a finger to guide their reading in order to focus themselves; or to solve math problems by navigating a mental grid, such as moving through a times table. In fact, studies associate this region with skillful math performance.
	Beyond sports, this region defines for us where we end and the rest of the world begins. [p][/p]Experiments show that professional meditators are able to decrease activity in this region and shift activity to other, frontal brain regions.
	This may explain ecstatic feelings of \"losing one's sense of self\" and \"merging with the universe\" during meditation.
	This region helps us identify objects. It may get active when we handle mystery objects while blindfolded or view oddball images like orange-colored apples. People who under-use this region may be somewhat clumsy or unaware of where they are and how their motion affects others. They may have poor aim or balance, or poor ability to predict the trajectories of objects around them. Some may even inappropriately intrude in other people's physical space.
	Using this region may frustrate us sometimes. [p][/p]People who over-rely on
	this region may feel highly self-protective, with a strong boundary or defensive stance between themselves and others.",
	"P4": "This region helps us grapple highly complex problems in a comprehensive, strategic way that simultaneously considers numerous risks, uncertainties, rewards, and outcomes. For example, if you are in mixed company and are wondering whether to tell a particular joke, you might use this region to quickly assess whether the overall impact will be good or ill in light of your audience's probable values, how much people have likely had to drink, any likely repercussions that might occur, the apparent demeanor of your host, and so forth. Notice how much uncertainty is embedded in this situation! Little, if anything, is taken as precise or absolute. Instead, it helps us weigh many pros and cons at once to arrive at intuitive solutions.
	Economists often study this region. In experiments, they ask people to solve economics problems. Maybe a card game offers a 25% chance to win $10 or a 75% chance to lose $3. Set aside personal circumstances such as whether $10
	means much; do you consider this a sporting game to play? When testing people who are trained to answer these questions, this region activates. 
	It appears to be responsible for weighing odds, risks, and uncertainties in an intuitive holistic way. This region may also aid us to solve a system of equations a collection of two or more mathematical expressions that share variables in a simultaneous way. It is no surprise that, as with region P3, studies associate this region with skillful math performance.
	[p][/p]Besides helping us strategize game scenarios and math problems, this region helps inform us where leverage points may lie to steer those games closer to our benefit. For example, we might seek to change the odds above more in our favor, with a 30% chance to win $10 or a70% chance to lose $3. This region considers nudging and gut intuitions as well as the numbers. Like region F4, it has a spatial quality and may make \"calculations\" based on the relative weight of different options. As a metaphor, each factor is like a planet with a gravitational pull, with some factors having far more pull than others. We can evaluate the sum of pulls from all directions to arrive at an average or best fit.
	Like regions F3, F4 and P3, a majority of people do not utilize this region as much as they could. For example, because most people are not savvy with economics, they tend to use other regions. When presented with a gambling scenario, a person might wonder how a casino owner would answer, invoking region F7, rather than solving the question strategically.
	[p][/p]Using this region can frustrate us sometimes, because not every activity in life is nicely resolved as a game of chance.",
	"T6": "This region lies next to region P4 and is diametrically opposite region F7. It is similar to both these regions but is highly future-oriented and relational. It activates when we pick a location, time or system and insert ourselves into it. For example, this region lets you know what \"will\" occur at your workplace tomorrow. Unlike region F7, this skill-set is not about acting \"as-if\" or dreaming up a fantasy. Nor is it about planning an outcome. Instead, it aids us seriously, offering predictions that will likely occur in actuality. Saying \"I will..\" really encourages activity in this region to foresee our future.
	This region is holistic as it notices and weighs many abstract spatial relationships at once. Imagine exploring an architectural model of a city with its many parts, layers, and details. Then focus on the spatial arrangements of the
	buildings to find patterns. Now, instead of a city, consider a model of the psyche or an organization or culture. This region is nonverbal and cannot, by itself, explain insights and predictions. Its offerings thus seem obvious or mysterious. This region also gets active when we consider symbolic meanings, such as what an icon, photo, musical score, or piece of clothing symbolizes. It's unclear how this fits with the future-oriented quality of this region, though symbols are a great way to holistically represent complex situations when we lack words and analytics to explain ourselves.
	Studies suggests this region helps women but not men to distinguish other people's faces in a holistic way. Men rely more on region T5 instead.
	[p][/p]People who under-use this region may be surprised by how their lives unfold. They fail to predict and deal with future events. Under-use also shows up when people confuse what will happen with what they hope to happen.
	Using this region can be frustrating sometimes. It is mostly nonverbal and lies next to region O2, which handles abstract visual impressions. Thus, using this region may evoke only symbols, vague visual glimpses, and a few words. Also, though it focuses on foreseeing the \"right\" future, it can assure nothing.",
	"O1": "People are highly visual. Consider what a camera registers: the impact of light on film, or a film equivalent. That's it. A camera cannot discern where one object ends and another begins because it does not know about depth, changes in lighting, distance, and so forth. Imagine a kitchen floor of black and white tiles. The camera doesn't know whether the black tiles are holes, black boxes on the floor, or what. It can't even consider these options. Our common sense notions of vision are so potent, it is hard to imagine not being able to see!
	When we really use this region, we go beyond its usual gifts. People who rely on this region are natural engineers and architects, able to mentally rotate objects, follow charts and diagrams with ease, and project how building elements will fit together in their mind's eye. They look at a chair and precisely see a piece of furniture in all of its component parts and the exact functionality of those parts. In fact, these folks may prefer to refer to charts and diagrams over other media because they find these so easy to use. They will also think spatially; for example, when searching for a lost object they will scan the environment in a methodical way so that they cover every nook without wasting effort. To some extent, this region can compensate for or mimic deductive reasoning, which is
	associated with region F3. The person visualizes problems using Venn-diagrams, tree-structures, and similar means in order to reason through problems visually. The result can be just as precise and perhaps faster;, though not all problems lend themselves to visual representation.
	While many people make active use of this region, others are challenged to understand charts and diagrams, which appear like a foreign language to them. This is an obstacle to mastering many technical and practical problem-solving tasks that rely on visual thinking.
	[p][/p]Using this region can be frustrating in a paradoxical way. We may visualize an object very precisely in our mind's eye, down to measurements and interlocking parts, yet completely lack the words to explain what we see.",
	"O2": "Like region O1, this region is incredibly visual. Unlike O1, it is imprecise and holistic. It concerns itself with visual themes: the various inter-relationships of elements that convey an image's overall balance and
	meaning. Rather than rotate or measure an image in your mind's eye, as region O1 does, this region allows
	us to consider many possible arrangements or themes at once to locate what best fits the image, whether we
	are creating it ourselves or trying to understand someone else's creation. Also unlike region O1, this region does not need to labor itself to consider all elements and sub-elements that comprise an image. Rather, a person who is skilled with this region can review and sort many images at a startlingly rapid pace. If region 01 can engineer for functionality, this region can provide breathtaking composition.
	We may use this region to size up and react quickly to a person or place. This may be its original evolutionary benefit. Just as tone of voice can carry a lot of meaning about a person's character and intentions, the way a person presents himself or herself visually can convey a lot of meaning before we interact. While this region does not focus on meaning making or facial recognition, it gives us a \"thousand words\" at a glance about everyone we meet, every object we notice, and every place we visit. We instantly detect a theme that may or may not resonate with us. Some people describe the sight of ugly design as physically painful while the sight of elegant design sends them to heaven. This suggests how 02 may link to other brain regions to provide a kinesthetic response to visual input. However we find a view, other regions are needed to provide words and suggest actions in response to what we see.
	[p][/p]People who under-use this region may be hard-pressed at \"art appreciation\". Photographs and pictures do not \"speak\" to them. Good design, they know not. Rather, they gravitate to environments that are functional, socially acceptable, and/or in line with their values. Similarly, and more detrimentally, some may be slow to evaluate people and places visually.
	Using this region can be frustrating sometimes. Visual sensibilities, abstract themes, and compositional skills are hard to explain. One's inchoate impressions of a person based on his or her look are equally challenging.",
}

# Area2D that contains all the region polygons and colliders
@onready var region_group: CanvasGroup = $BrainRegions
@onready var brain_area: CollisionPolygon2D = $BrainRegions/BrainArea/BrainCollision
@onready var brain_area_offset: PackedVector2Array

@onready var brain_offset = position

@onready var region_offsets:Dictionary = {}
# Array of Polygon2D's that serve as the brain regions.
var regions: Array
@onready var current_region_activity: Dictionary = {}
# Array of colors that represent different activity levels
var colors = [
	Color(0,0,255,1),
	Color(0,255,0,1),
	Color(247,225,0),
	Color(255,0,0,1),
	Color(255, 0, 255,1),
	Color(255,255,255,1)
]
# Dictionaries to translate color indexes from numbers to strings or strings to numbers.
var activity_intToString = {0:"low",1:"medium",2:"high",3:"very high",4:"hovered",5:"none"}
var activity_stringToInt = {"low":0,"medium":1,"high":2,"very high":3,"hovered":4,"none":5}
# Name of currently hovered region
var hovered
# Color of currently hovered region
var restoreColor: Color = colors[5]

# State Chart
@export var state_chart: StateChart




#TODO: Remove collision shapes since the signals don't work correctly.


# Start of functions  **********************************************************
# Called when the node enters the scene tree for the first time.
func _ready():
	for point in brain_area.polygon:
		brain_area_offset.append(point + brain_offset)

	
	#area.set_block_signals(true)
	# Load all the polygon2D's into an array.
	setup_regions()
	for region in regions:
		current_region_activity[region.name] = 0
	setup_polygon_offsets()
	# Set all regions color to default
	set_activity_by_type("")
	print(current_region_activity)
	#switch_type()

func _draw():
	#draw_polygon(region_offsets["F7"],[Color.BLUE])
	pass

func setup_regions():
	regions = region_group.get_children().filter(func(r): return r is Polygon2D)
	emit_signal("regionsReady")



func _process(_delta):
	hovered = handle_region_hover()
	
	regions.map(func(r): r.color = colors[current_region_activity[r.name]])
	if hovered[0]:
		hovered[1].color = Color.PURPLE
	pass

func switch_type():
	get_tree().create_timer(0.2).connect("timeout",switch_type)
	set_activity_by_type(types.pick_random())


func setup_polygon_offsets():
	for region in regions:
		var collision_shape:PackedVector2Array = PackedVector2Array()
		var polygon = region.polygon
		for i in range(len(region.polygon)):
			#print("Before -> ", collision_shape[i])
			var new_point: Vector2 = (polygon[i] + (region.position)) + brain_offset
			collision_shape.append(new_point)
			#print("After -> ", collision_shape[i])
		region_offsets[region.name] = collision_shape


func handle_region_hover():
	var hovered_region = regions.filter(func(r): return Geometry2D.is_point_in_polygon(get_global_mouse_position(),region_offsets[r.name]))
	if len(hovered_region) > 0:
		return [true,hovered_region[0]]
	else:
		return [false,null]


func is_mouse_in_brain_area():
	return Geometry2D.is_point_in_polygon(get_global_mouse_position(),brain_area_offset)
		
# Setters ==================================================================================

func set_region_activity(region,activity):
	region.color = colors[activity]

func set_activity_by_type(type):
	if types.has(type):
		for i in range(len(intensity[type])):
			for region in intensity[type][i]:
				current_region_activity[region] = i
	else:
		regions.map(func(r): r.color = colors[5])

# Getters =========================================================================================

func get_region_by_name(name):
	return regions.filter(func(r): return r.name == name)[0]

func get_region_info(region_name: String):
	var region_info = {
		"name":region_name,
		"summary":region_summaries[region_name],
		"description":region_descriptions[region_name]
	}
	return region_info

# Signal Events **********************************************************



#Set the regions activity levels once a new type is selected.
func _on_guide_screen_type_selected(typeSelected):
	print("Type Selected:", typeSelected)
	#resetRegionColors()
	#setActivityByType(typeSelected)
	pass # Replace with function body.


# Listen for regions being clicked.
func _on_regions_area_input_event(_viewport, _event, _shape_idx):
	# if(_event is InputEventMouseButton and _event.pressed == true):
	# 	print("Brain clicked.")
	# if(_event is InputEventMouseMotion):
	# 	var hover = regions.filter(func(r): return Geometry2D.is_point_in_polygon(get_global_mouse_position(),region_offsets[r.name]))
	# 	print(hover)
		# for region in regions:
		# 	if Geometry2D.is_point_in_polygon(get_global_mouse_position(),region_offsets[region.name]):
		# 		region.color = Color.PURPLE
	pass



func _on_low_state_entered():

	pass # Replace with function body.
