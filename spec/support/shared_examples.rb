# typed: false
# frozen_string_literal: true

# Shared examples for ActsAsMessageable that work with both ActiveRecord and Mongoid
# Usage:
#   include_examples 'acts_as_messageable', adapter: :active_record
#   include_examples 'acts_as_messageable', adapter: :mongoid
RSpec.shared_examples 'acts_as_messageable' do |adapter:|
  describe 'send messages' do
    it 'alice should have one message' do
      expect(@alice.messages.count).to eq(1)
    end

    it 'alice should have one message from bob' do
      expect(@alice.messages.are_from(@bob).count).to eq(1)
    end

    it 'bob should have one message' do
      expect(@bob.messages.count).to eq(1)
    end

    it 'bob should have one message to alice in outbox' do
      expect(@bob.sent_messages.are_to(@alice).count).to eq(1)
    end

    it 'bob should have one open message from alice' do
      @alice.messages.are_from(@bob).process(&:open)
      expect(@alice.messages.readed.count).to eq(1)
    end
  end

  describe 'send messages with bang' do
    it 'should raise exception' do
      error_class = adapter == :mongoid ? Mongoid::Errors::Validations : ActiveRecord::RecordInvalid
      expect do
        @alice.send_message!(@bob, body: 'body')
      end.to raise_error(error_class)
    end

    it 'should return message object' do
      message_class = adapter == :mongoid ? ActsAsMessageable::Mongoid::Message : ActsAsMessageable::Message
      expect(@alice.send_message!(@bob, body: 'body', topic: 'topic')).to be_kind_of(message_class)
    end
  end

  describe 'inheritance models' do
    it 'men send message to alice' do
      send_test_message(@men, @alice)
      expect(@men.sent_messages.size).to be_equal(1)
      expect(@alice.received_messages.size).to be_equal(2)
    end

    it 'messages method should receive all messages connected with user' do
      send_test_message(@men, @alice)
      expect(@men.messages.size).to be_equal(1)
    end

    it 'men send message and receive from alice' do
      send_test_message(@men, @alice)
      send_test_message(@alice, @men)

      expect(@men.messages.size).to be_equal(2)
      expect(@men.sent_messages.size).to be_equal(1)
      expect(@men.received_messages.size).to be_equal(1)
    end
  end

  describe 'reply to messages' do
    it 'pat should not be able to reply to a message from bob to alice' do
      @reply_message = @pat.reply_to(@message, 'Re: Topic', 'Body')
      expect(@reply_message).to be_nil
    end

    it 'alice should be able to reply to a message from bob to alice' do
      @reply_message = @alice.reply_to(@message, 'Re: Topic', 'Body')
      expect(@reply_message).not_to be_nil
      expect(@bob.messages.are_from(@alice).count).to eq(1)
      expect(@alice.sent_messages.are_to(@bob).count).to eq(1)
    end

    it 'alice should be able to reply to a message using the message object' do
      @reply_message = @message.reply('Re: Topic', 'Body')
      expect(@reply_message).not_to be_nil
      expect(@bob.messages.are_from(@alice).count).to eq(1)
      expect(@alice.sent_messages.are_to(@bob).count).to eq(1)
    end

    it 'bob try to add something to conversation' do
      @reply_message = @bob.reply_to(@message, 'Oh, I Forget', '1+1=2')
      expect(@reply_message.from).to eq(@message.from)
      expect(@reply_message.to).to eq(@message.to)
    end

    it 'bob try to add something to conversation and should receive proper order' do
      @reply_message = @bob.reply_to(@message, 'Oh, I Forget', '1+1=2')
      @sec_message = @alice.reply_to(@message, 'Yeah, right', '1+1=3!')

      # Mongoid returns Criteria, ActiveRecord returns Relation - both need to_a for comparison
      expect(@message.conversation.to_a).to eq([@sec_message, @reply_message, @message])
    end
  end

  describe 'delete messages' do
    it 'bob should have one deleted message from alice' do
      @bob.messages.process(&:delete)

      @bob.messages.each do |m|
        expect(m.recipient_delete).to eq(true)
        expect(m.sender_delete).to eq(false)
      end

      expect(@bob.deleted_messages.count).to eq(1)
      expect(@bob.messages.count).to eq(0)
    end

    it 'received_messages and sent_messages should work with .process method' do
      expect(@bob.sent_messages.count).to eq(1)
      expect(@alice.received_messages.count).to eq(1)

      @bob.sent_messages.process(&:delete)
      expect(@bob.sent_messages.count).to eq(0)
      expect(@alice.received_messages.count).to eq(1)

      @alice.received_messages.process(&:delete)
      expect(@alice.received_messages.count).to eq(0)
    end

    it 'message should permanent delete' do
      @alice.messages.process(&:delete)
      expect(@alice.messages.count).to eq(0)

      expect(@alice.deleted_messages.count).to eq(1)
      @alice.deleted_messages.process(&:delete)
      expect(@alice.deleted_messages.count).to eq(0)

      @message.reload
      expect(@message.recipient_permanent_delete).to eq(true)

      expect(@bob.sent_messages.count).to eq(1)
    end

    it 'pat should not able to delete message' do
      expect { @pat.delete_message(@message) }.to raise_error(RuntimeError)
    end
  end

  describe 'restore message' do
    it 'alice should restore message' do
      @alice.received_messages.process(&:delete)
      @alice.restore_message(@message.reload)
      expect(@alice.received_messages.count).to eq(1)
    end

    it 'bob should be able to restore message' do
      @bob.sent_messages.process(&:delete)
      @bob.restore_message(@message.reload)
      expect(@bob.sent_messages.count).to eq(1)
    end

    it 'should works with relation' do
      @alice.received_messages.process(&:delete)
      expect(@alice.received_messages.count).to eq(0)
      @alice.deleted_messages.process(&:restore)
      expect(@alice.received_messages.count).to eq(1)
    end

    it 'pat should not able to restore message' do
      expect { @pat.restore_message(@message) }.to raise_error(RuntimeError)
    end
  end

  describe 'read/unread feature' do
    it 'alice should have one unread message from bob' do
      expect(@alice.messages.are_from(@bob).unreaded.count).to eq(1)
      expect(@alice.messages.are_from(@bob).readed.count).to eq(0)
      expect(@alice.messages.are_from(@bob).readed.all?(&:open?)).to be_truthy
    end

    it 'alice should able to read message from bob' do
      @alice.messages.are_from(@bob).first.read
      expect(@alice.messages.are_from(@bob).unreaded.count).to eq(0)
    end

    it 'alice should able to unread message from bob' do
      @alice.messages.are_from(@bob).first.read
      @alice.messages.are_from(@bob).first.unread
      expect(@alice.messages.are_from(@bob).unreaded.count).to eq(1)
    end

    it 'alice should see the read_at updated' do
      date_time_when_read = Time.new(2014, 9, 4, 15, 12, 34)
      Timecop.freeze(date_time_when_read) do
        @alice.messages.are_from(@bob).first.read
        first_message = @alice.messages.are_from(@bob).first
        expect(first_message.opened_at.to_i).to eql(date_time_when_read.to_i)
      end
    end

    describe '#open?' do
      let(:message) { @alice.messages.are_from(@bob).first }

      it 'returns false for closed message' do
        expect(message.open?).to be_falsey
      end

      it 'returns true for open message' do
        message.read
        expect(message.open?).to be_truthy
      end
    end
  end

  it 'finds proper message' do
    @bob.messages.find(@message.id) == @message
  end

  it 'message should have proper topic' do
    expect(@bob.messages.count).to eq(1)
    @bob.messages.first.topic == 'Topic'
  end

  describe 'conversation' do
    it 'bob send message to alice, and alice reply to bob message and show proper tree' do
      @reply_message = @alice.reply_to(@message, 'Re: Topic', 'Body')

      expect(@reply_message.conversation.size).to eq(2)
      expect(@reply_message.conversation.last.topic).to eq('Topic')
      expect(@reply_message.conversation.first.topic).to eq('Re: Topic')
    end

    it 'bob send message to alice, alice answer, and bob answer for alice answer' do
      @reply_message = @alice.reply_to(@message, 'Re: Topic', 'Body')
      @reply_reply_message = @bob.reply_to(@reply_message, 'Re: Re: Topic', 'Body')

      [@message, @reply_message, @reply_reply_message].each do |m|
        expect(m.conversation.size).to eq(3)
      end

      expect(@message.conversation.first).to eq(@reply_reply_message)
      expect(@reply_reply_message.conversation.first).to eq(@reply_reply_message)
    end
  end

  describe 'conversations' do
    before do
      @reply_message = @message.reply('Re: Topic', 'Body')
      @reply_reply_message = @reply_message.reply('Re: Re: Topic', 'Body')
    end

    it 'bob send message to alice and alice reply' do
      expect(@bob.messages.conversations).to eq([@reply_reply_message])
      expect(@reply_message.conversation.to_a).to eq([@reply_reply_message, @reply_message, @message])
    end

    it 'show conversations in proper order' do
      @sec_message = @bob.send_message(@alice, 'Hi', 'Alice!')
      @sec_reply = @sec_message.reply('Re: Hi', 'Fine!')
      expect(@bob.received_messages.conversations.map(&:id)).to eq([@sec_reply.id, @reply_reply_message.id])
      expect(@sec_reply.conversation.to_a).to eq([@sec_reply, @sec_message])
    end
  end

  describe 'search text from messages' do
    before do
      @reply_message = @message.reply('Re: Topic', 'Body : I am fine')
      @reply_reply_message = @reply_message.reply('Re: Re: Topic', 'Fine too')
    end

    it 'bob should be able to search text from messages' do
      recordset = @bob.messages.search('I am fine')
      expect(recordset.count).to eq(1)
      expect(recordset).not_to be_nil
    end
  end

  describe 'send messages with hash' do
    it 'send message with hash' do
      @message = @bob.send_message(@alice, body: 'Body', topic: 'Topic')
      expect(@message.topic).to eq('Topic')
      expect(@message.body).to eq('Body')
    end
  end

  it 'messages should return in right order :created_at' do
    @message = send_test_message(@bob, @alice, 'Example', 'Example Body')
    expect(@alice.messages.last.body).to eq('Body')
  end

  describe 'send messages between two different models (the same id)' do
    it 'bob send message to admin (different model) with the same id' do
      @bob.send_message(@alice, 'hello', 'alice')
      expect(@alice.messages.are_to(@alice).size).to be_equal(2)
      expect(@alice.messages.are_to(@admin).size).to be_equal(0)
    end

    it 'admin send message to bob' do
      @admin.send_message(@bob, 'hello', 'bob')
      expect(@bob.messages.are_from(@admin).size).to be_equal(1)
      expect(@bob.messages.are_from(@alice).size).to be_equal(0)
    end
  end

  describe 'mass assignment' do
    it 'allows to mass assign topic and body attributes' do
      @message = send_test_message(@bob, @alice, 'Example', 'Example Body')
      @message.update!(topic: 'Changed topic', body: 'Changed body')

      expect(@message.topic).to eq('Changed topic')
      expect(@message.body).to eq('Changed body')
    end
  end

  describe 'tree structure (ancestry)' do
    it 'message without parent is its own root' do
      expect(@message.root).to eq(@message)
    end

    it 'reply has original message as root' do
      @reply_message = @alice.reply_to(@message, 'Re: Topic', 'Body')
      expect(@reply_message.root).to eq(@message)
    end

    it 'nested reply has original message as root' do
      @reply_message = @alice.reply_to(@message, 'Re: Topic', 'Body')
      @reply_reply_message = @bob.reply_to(@reply_message, 'Re: Re: Topic', 'Body')
      expect(@reply_reply_message.root).to eq(@message)
    end

    it 'subtree includes all messages in conversation thread' do
      @reply_message = @alice.reply_to(@message, 'Re: Topic', 'Body')
      @reply_reply_message = @bob.reply_to(@reply_message, 'Re: Re: Topic', 'Body')

      subtree = @message.subtree.to_a
      expect(subtree).to include(@message, @reply_message, @reply_reply_message)
    end

    it 'conversation returns messages in correct order (newest first)' do
      @reply_message = @alice.reply_to(@message, 'Re: Topic', 'Body')
      @reply_reply_message = @bob.reply_to(@reply_message, 'Re: Re: Topic', 'Body')

      expect(@message.conversation.to_a).to eq([@reply_reply_message, @reply_message, @message])
    end
  end
end
