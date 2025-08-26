require 'rails_helper'

RSpec.describe GalleriesController, type: :controller do
  let(:user) { User.create!(email: 'test@example.com', password: 'password123', 
                           first_name: 'Vivian', last_name: 'Kim') }
  let(:other_user) { User.create!(email: 'other@example.com', password: 'password123',
                                 first_name: 'Jane', last_name: 'Smith') }
  let(:gallery) { Gallery.create!(title: 'Test Gallery', user: user, status: 'published') }

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'shows published galleries to non-logged in users' do
      get :index
      expect(assigns(:galleries)).to include(gallery)
    end
  end

  describe 'GET #show' do
    context 'with published gallery' do
      it 'returns a success response for anyone' do
        get :show, params: { id: gallery.id }
        expect(response).to be_successful
      end
    end

    context 'with draft gallery' do
      let(:draft_gallery) { Gallery.create!(title: 'Draft Gallery', user: user, status: 'draft') }

      it 'allows owner to view' do
        sign_in user
        get :show, params: { id: draft_gallery.id }
        expect(response).to be_successful
      end

      it 'redirects non-owner' do
        sign_in other_user
        get :show, params: { id: draft_gallery.id }
        expect(response).to redirect_to(galleries_path)
      end
    end
  end

  describe 'GET #new' do
    context 'when user is not logged in' do
      it 'redirects to login' do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is logged in' do
      before { sign_in user }

      it 'returns a success response' do
        get :new
        expect(response).to be_successful
      end
    end
  end

  describe 'POST #create' do
    context 'when user is not logged in' do
      it 'redirects to login' do
        post :create, params: { gallery: { title: 'Test Gallery' } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is logged in' do
      before { sign_in user }

      context 'with valid params' do
        it 'creates a new gallery' do
          expect {
            post :create, params: { gallery: { title: 'New Gallery', description: 'Description' } }
          }.to change(Gallery, :count).by(1)
        end

        it 'redirects to the created gallery' do
          post :create, params: { gallery: { title: 'New Gallery', description: 'Description' } }
          expect(response).to redirect_to(Gallery.last)
        end
      end

      context 'with invalid params' do
        it 'does not create a gallery' do
          expect {
            post :create, params: { gallery: { title: '' } }
          }.to_not change(Gallery, :count)
        end
      end
    end
  end

  describe 'PUT #update' do
    context 'when user is not the gallery owner' do
      before { sign_in other_user }

      it 'redirects with access denied' do
        put :update, params: { id: gallery.id, gallery: { title: 'Updated Title' } }
        expect(response).to redirect_to(galleries_path)
      end
    end

    context 'when user is the gallery owner' do
      before { sign_in user }

      context 'with valid params' do
        it 'updates the gallery' do
          put :update, params: { id: gallery.id, gallery: { title: 'Updated Title' } }
          gallery.reload
          expect(gallery.title).to eq('Updated Title')
        end

        it 'redirects to the gallery' do
          put :update, params: { id: gallery.id, gallery: { title: 'Updated Title' } }
          expect(response).to redirect_to(gallery)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:gallery_to_delete) { Gallery.create!(title: 'To Delete', user: user) }

    context 'when user is not the gallery owner' do
      before { sign_in other_user }

      it 'does not delete the gallery' do
        expect {
          delete :destroy, params: { id: gallery_to_delete.id }
        }.to_not change(Gallery, :count)
      end
    end

    context 'when user is the gallery owner' do
      before { sign_in user }

      it 'deletes the gallery' do
        expect {
          delete :destroy, params: { id: gallery_to_delete.id }
        }.to change(Gallery, :count).by(-1)
      end

      it 'redirects to galleries index' do
        delete :destroy, params: { id: gallery_to_delete.id }
        expect(response).to redirect_to(galleries_path)
      end
    end
  end
end