const request = require('supertest'),
    chai = require('chai'),
    app = require('../app.js')

chai.should();

describe('Index Page', () => {
    it('should redirect to /todo', (done) => {
        request(app)
            .get('/')
            .expect(302)
            .expect('Location', /\/todo/, done)
    });
});

describe('404 redirect', () => {
    it('should redirect to the home page', (done) => {
        request(app)
            .get('/404')
            .expect(302)
            .expect('Location', /\/todo/, done)
    });
});

describe('Create todo', () => {
    it('should create todo item and redirect to /todo', (done) => {
        request(app)
            .post('/todo/add/')
            .type('form')
            .send({
                newtodo: "newTodo"
            })
            .expect(302)
            .expect('Location', /\/todo/, () => {
                request(app)
                    .get('/todo')
                    .expect(200)
                    .end((err, res) => {
                        if (err) return done(err);
                        res.text.should.contain('newTodo');
                        done();
                    })
            })
    })
})
describe('Get todo', () => {
    it('should return todo item', (done) => {
        request(app)
            .get('/todo/0')
            .expect(200)
            .end((err, res) => {
                if (err) return done(err);
                res.text.should.contain('Edit newTodo');
                done();
            })
    })
})
describe('Get nonexistent todo', () => {
    it('should redirect to /todo', (done) => {
        request(app)
            .get('/todo/11')
            .expect(302)
            .expect('Location', /\/todo/, done)
    })
})
describe('Edit todo', () => {
    it('should edit todo item PUT and redirect to /todo', (done) => {
        request(app)
            .put('/todo/edit/0')
            .type('form')
            .send({
                editTodo: "editTodo"
            })
            .expect(302)
            .expect('Location', /\/todo/, () => {
                request(app)
                    .get('/todo')
                    .expect(200)
                    .end((err, res) => {
                        if (err) return done(err);
                        res.text.should.contain('editTodo');
                        done();
                    })
            })
    })
})


describe('Delete todo', () => {
    it('should delete todo item and redirect to /todo', (done) => {
        request(app)
            .get('/todo/delete/0')
            .expect(302)
            .expect('Location', /\/todo/, () => {
                request(app)
                    .get('/todo')
                    .expect(200)
                    .end((err, res) => {
                        if (err) return done(err);
                        res.text.should.not.contain('<li>');
                        done();
                    })
            })
    })
})
