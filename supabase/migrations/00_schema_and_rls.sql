-- Enable Row Level Security (RLS) for all tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE profile_photos ENABLE ROW LEVEL SECURITY;
ALTER TABLE interests ENABLE ROW LEVEL SECURITY;
ALTER TABLE matches ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_rooms ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE blocked_users ENABLE ROW LEVEL SECURITY;
ALTER TABLE reports ENABLE ROW LEVEL SECURITY;

-- Profiles: Anyone can view profiles, but only the owner can update their own
CREATE POLICY "Public profiles are viewable by everyone." 
ON profiles FOR SELECT USING (true);

CREATE POLICY "Users can insert their own profile." 
ON profiles FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can update own profile." 
ON profiles FOR UPDATE USING (auth.uid() = id);

-- Profile Photos: Anyone can view, owner can insert/update/delete
CREATE POLICY "Photos are viewable by everyone." 
ON profile_photos FOR SELECT USING (true);

CREATE POLICY "Users can insert their own photos." 
ON profile_photos FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own photos." 
ON profile_photos FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own photos." 
ON profile_photos FOR DELETE USING (auth.uid() = user_id);

-- Interests: Viewable by sender and receiver, sender can insert, receiver can update status
CREATE POLICY "Users can view their interests." 
ON interests FOR SELECT USING (auth.uid() = sender_id OR auth.uid() = receiver_id);

CREATE POLICY "Users can send interests." 
ON interests FOR INSERT WITH CHECK (auth.uid() = sender_id);

CREATE POLICY "Receiver can update interest status." 
ON interests FOR UPDATE USING (auth.uid() = receiver_id);

-- Matches: Viewable by both users
CREATE POLICY "Users can view their matches." 
ON matches FOR SELECT USING (auth.uid() = user1_id OR auth.uid() = user2_id);

-- Depending on your business logic, matches might be inserted by a server-side trigger or client
CREATE POLICY "Users can insert matches." 
ON matches FOR INSERT WITH CHECK (auth.uid() = user1_id OR auth.uid() = user2_id);

-- Chat Rooms: Viewable by matched users (needs a join or simpler approach)
-- Assuming if they are in the match, they can see the chat room. 
CREATE POLICY "Users can view their chat rooms." 
ON chat_rooms FOR SELECT USING (
  match_id IN (SELECT id FROM matches WHERE user1_id = auth.uid() OR user2_id = auth.uid())
);

CREATE POLICY "Users can insert chat rooms." 
ON chat_rooms FOR INSERT WITH CHECK (true);

-- Messages: Viewable by chat room members, sender can insert
CREATE POLICY "Users can view their messages." 
ON messages FOR SELECT USING (
  chat_room_id IN (
    SELECT cr.id FROM chat_rooms cr 
    JOIN matches m ON cr.match_id = m.id 
    WHERE m.user1_id = auth.uid() OR m.user2_id = auth.uid()
  )
);

CREATE POLICY "Sender can insert message." 
ON messages FOR INSERT WITH CHECK (auth.uid() = sender_id);

CREATE POLICY "Receiver can update message to read." 
ON messages FOR UPDATE USING (auth.uid() != sender_id);

-- Notifications: Only receiver can view/update
CREATE POLICY "Users can view their own notifications." 
ON notifications FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "System or users can insert notifications." 
ON notifications FOR INSERT WITH CHECK (true);

CREATE POLICY "Users can update their own notifications." 
ON notifications FOR UPDATE USING (auth.uid() = user_id);

-- Subscriptions: User can view their own
CREATE POLICY "Users can view their subscriptions." 
ON subscriptions FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert subscriptions." 
ON subscriptions FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Blocked Users: Only blocker can view
CREATE POLICY "Blocker can view blocks." 
ON blocked_users FOR SELECT USING (auth.uid() = blocker_id);

CREATE POLICY "Blocker can insert block." 
ON blocked_users FOR INSERT WITH CHECK (auth.uid() = blocker_id);

-- Reports: Only reporter can view/insert
CREATE POLICY "Reporter can view reports." 
ON reports FOR SELECT USING (auth.uid() = reporter_id);

CREATE POLICY "Reporter can insert report." 
ON reports FOR INSERT WITH CHECK (auth.uid() = reporter_id);
